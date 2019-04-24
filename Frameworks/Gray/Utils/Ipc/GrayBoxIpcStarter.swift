import MixboxFoundation
import MixboxInAppServices
import MixboxIpc

final class GrayBoxIpcStarter: IpcStarter {
    let sameProcessIpcClientServer = SameProcessIpcClientServer()
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> (IpcRouter, IpcClient?) {
        commandsForAddingRoutes.forEach { command in
            command(sameProcessIpcClientServer)
        }
        
        return (sameProcessIpcClientServer, sameProcessIpcClientServer)
    }
}
