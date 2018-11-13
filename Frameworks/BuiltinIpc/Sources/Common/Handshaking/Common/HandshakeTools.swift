import MixboxIpc
import MixboxFoundation

// Just code that is reused in few places.
final class HandshakeTools {
    let ipcClientHolder: IpcClientHolderImpl
    let ipcCallbackStorage: IpcCallbackStorage
    let decoderFactory: DecoderFactory
    let encoderFactory: EncoderFactory
    let server: BuiltinIpcServer
    let bonjourServiceSettings: BonjourServiceSettings?
    
    // ipcClientHolder might not retain it strongly
    private var client: IpcClient?
    
    var onHandshake: ((IpcClient?) -> ())? {
        didSet {
            condition.lock()
            if let client = client {
                onHandshake?(client)
            }
            condition.unlock()
        }
    }
    
    private var condition = NSCondition()
    
    init(bonjourServiceSettings: BonjourServiceSettings? = nil) {
        self.bonjourServiceSettings = bonjourServiceSettings
        
        ipcCallbackStorage = IpcCallbackStorageImpl()
        ipcClientHolder = IpcClientHolderImpl()
        let decoderFactory = DecoderFactoryImpl(
            ipcClientHolder: ipcClientHolder
        )
        let encoderFactory = EncoderFactoryImpl(
            ipcCallbackStorage: ipcCallbackStorage
        )
        
        encoderFactory.decoderFactory = decoderFactory
        decoderFactory.encoderFactory = encoderFactory
        
        self.encoderFactory = encoderFactory
        self.decoderFactory = decoderFactory
        
        server = BuiltinIpcServer(
            bonjourServiceSettings: bonjourServiceSettings,
            encoderFactory: encoderFactory,
            decoderFactory: decoderFactory
        )
        
        setUpCallIpcCallbackIpcMethodHandler()
    }
    
    
    func makeClient(host: String, port: UInt) -> BuiltinIpcClient {
        let client = BuiltinIpcClient(
            host: host,
            port: port,
            encoderFactory: encoderFactory,
            decoderFactory: decoderFactory
        )
        
        self.client = client
        ipcClientHolder.ipcClient = client
        
        return client
    }
    
    @discardableResult
    func startServer() -> UInt? {
        return server.start()
    }
    
    func waitForHandshake() -> IpcClient? {
        if let client = client {
            return client
        } else {
            while client == nil {
                condition.lock()
                condition.wait()
                condition.unlock()
            }
            return client
        }
    }
    
    func setUpHandshakeIpcMethodHandler() {
        let handshakeIpcMethodHandler = HandshakeIpcMethodHandler()
        handshakeIpcMethodHandler.onHandshake = { [weak self] port in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.condition.lock()
            let client = strongSelf.makeClient(
                host: Constants.hostname,
                port: port
            )
            strongSelf.condition.broadcast()
            strongSelf.condition.unlock()
            
            strongSelf.onHandshake?(client)
        }
        server.register(methodHandler: handshakeIpcMethodHandler)
    }
    
    private func setUpCallIpcCallbackIpcMethodHandler() {
        let callIpcCallbackIpcMethodHandler = CallIpcCallbackIpcMethodHandler(
            ipcCallbackStorage: ipcCallbackStorage
        )
        server.register(methodHandler: callIpcCallbackIpcMethodHandler)
    }
}
