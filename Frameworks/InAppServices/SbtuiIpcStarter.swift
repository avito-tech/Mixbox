import MixboxIpc
import SBTUITestTunnel
import MixboxIpcSbtuiHost

final class SbtuiIpcStarter: IpcStarter {
    private let router = SbtuiIpcRouter()
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) -> (IpcRouter, IpcClient?) {
        SBTUITestTunnelServer.takeOff()
        
        // https://github.com/Subito-it/SBTUITestTunnel/blob/master/Documentation/Setup.md
        //
        // The doc says that if you simply use `.takeOff()` and app is launching slowly,
        // then there can be bugs and instabilities in tests.
        //
        // I am not sure that we experienced any of those bugs, but I followed the doc and now
        // I don't feel myself safe imagining to remove this.
        //
        // The doc says that we should call `takeOffCompleted(false)` right after `takeOff()`
        // And then when the app is fully loaded, call `takeOffCompleted(true)`.
        
        SBTUITestTunnelServer.takeOffCompleted(false)
        
        commandsForAddingRoutes.forEach { $0(router) }
        
        return (router, nil)
    }
    
    func handleUiBecomeVisible() {
        SBTUITestTunnelServer.takeOffCompleted(true)
    }
}
