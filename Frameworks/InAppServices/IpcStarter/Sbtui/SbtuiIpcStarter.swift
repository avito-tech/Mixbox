#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import SBTUITestTunnel
import MixboxIpcSbtuiHost

final class SbtuiIpcStarter: IpcStarter {
    private let router: SbtuiIpcRouter
    
    // reregisterMethodHandlersAutomatically == true disables asserion if method is registered twice. not recommended.
    init(reregisterMethodHandlersAutomatically: Bool) {
        self.router = SbtuiIpcRouter(
            reregisterMethodHandlersAutomatically: reregisterMethodHandlersAutomatically
        )
    }
    
    func start(commandsForAddingRoutes: [(IpcRouter) -> ()]) throws -> (IpcRouter, IpcClient?) {
        SBTUITestTunnelServer.takeOff()
        
        commandsForAddingRoutes.forEach { $0(router) }
        
        return (router, nil)
    }
}

#endif
