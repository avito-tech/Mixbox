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
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> IpcRouter {
        let client = BuiltinIpcClient(
            host: testRunnerHost,
            port: testRunnerPort
        )
        
        let server = BuiltinIpcServer()
        if let localPort = server.start() {
            commandsForAddingRoutes.forEach { $0(server) }
            client.handshake(localPort: localPort)
        }
        return server
    }
    
    func handleUiBecomeVisible() {
        // not needed
    }
}
