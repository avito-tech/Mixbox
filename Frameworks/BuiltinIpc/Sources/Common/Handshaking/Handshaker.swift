import MixboxIpc

// Usage:
//
// let port = handshaker.start()
//
// launch_child_process_that_will_send_handshake_back(port)
//
// let client = handshaker.waitForHandshake()
//
// use_your_client(client)
//
public final class Handshaker {
    public let server: BuiltinIpcServer
    
    private var client: IpcClient?
    private let dispatchGroup = DispatchGroup()
    
    public init() {
        let ipcCallbackStorage = IpcCallbackStorageImpl()
        let ipcClientHolder = IpcClientHolderImpl()
        let decoderFactory = DecoderFactoryImpl(
            ipcClientHolder: ipcClientHolder
        )
        let encoderFactory = EncoderFactoryImpl(
            ipcCallbackStorage: ipcCallbackStorage
        )
        encoderFactory.decoderFactory = decoderFactory
        decoderFactory.encoderFactory = encoderFactory
        
        server = BuiltinIpcServer(
            encoderFactory: encoderFactory,
            decoderFactory: decoderFactory
        )
        
        dispatchGroup.enter()
        let handshakeIpcMethodHandler = HandshakeIpcMethodHandler()
        handshakeIpcMethodHandler.onHandshake = { [weak self, dispatchGroup] port in
            let client = BuiltinIpcClient(
                host: "localhost",
                port: port,
                encoderFactory: encoderFactory,
                decoderFactory: decoderFactory
            )
            ipcClientHolder.ipcClient = client
            self?.client = client
            
            dispatchGroup.leave()
        }
        server.register(methodHandler: handshakeIpcMethodHandler)
        
        let callIpcCallbackIpcMethodHandler = CallIpcCallbackIpcMethodHandler(
            ipcCallbackStorage: ipcCallbackStorage
        )
        server.register(methodHandler: callIpcCallbackIpcMethodHandler)
    }
    
    public func start() -> UInt? {
        return server.start()
    }
    
    public func waitForHandshake() -> IpcClient? {
        if let client = client {
            return client
        } else {
            dispatchGroup.wait()
            return client
        }
    }
}
