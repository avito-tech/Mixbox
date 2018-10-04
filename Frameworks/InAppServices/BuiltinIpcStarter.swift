import MixboxIpc
import MixboxBuiltinIpc

final class BuiltinIpcStarter: IpcStarter {
    private let testRunnerHost: String
    private let testRunnerPort: UInt
    
    init(
        testRunnerHost: String,
        testRunnerPort: UInt)
    {
        self.testRunnerHost = testRunnerHost
        self.testRunnerPort = testRunnerPort
    }
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> (IpcRouter, IpcClient?) {
        let ipcCallbackStorage = IpcCallbackStorageImpl()
        let ipcClientHolder = IpcClientHolderImpl()
        let decoderFactory = DecoderFactoryImpl(ipcClientHolder: ipcClientHolder)
        let encoderFactory = EncoderFactoryImpl(ipcCallbackStorage: ipcCallbackStorage)
        encoderFactory.decoderFactory = decoderFactory
        decoderFactory.encoderFactory = encoderFactory
        
        let client = BuiltinIpcClient(
            host: testRunnerHost,
            port: testRunnerPort,
            encoderFactory: encoderFactory,
            decoderFactory: decoderFactory
        )
        ipcClientHolder.ipcClient = client
        
        let callIpcCallbackIpcMethodHandler = CallIpcCallbackIpcMethodHandler(ipcCallbackStorage: ipcCallbackStorage)
        
        let server = BuiltinIpcServer(
            encoderFactory: encoderFactory,
            decoderFactory: decoderFactory
        )
        server.register(methodHandler: callIpcCallbackIpcMethodHandler)
        if let localPort = server.start() {
            commandsForAddingRoutes.forEach { $0(server) }
            client.handshake(localPort: localPort)
        }
        return (server, client)
    }
    
    func handleUiBecomeVisible() {
        // not needed
    }
}
