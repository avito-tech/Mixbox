#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import SBTUITestTunnel
import MixboxIpcSbtuiHost

final class SbtuiIpcStarter: IpcStarter {
    private let ipcRouter: SbtuiIpcRouter
    
    // reregisterMethodHandlersAutomatically == true disables asserion if method is registered twice. not recommended.
    init(reregisterMethodHandlersAutomatically: Bool) {
        self.ipcRouter = SbtuiIpcRouter(
            reregisterMethodHandlersAutomatically: reregisterMethodHandlersAutomatically
        )
    }
    
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> (IpcRouter, IpcClient?) {
        SBTUITestTunnelServer.takeOff()
        
        let ipcClient: IpcClient? = nil
        
        let dependencies = IpcMethodHandlerRegistrationDependencies(
            ipcRouter: ipcRouter,
            ipcClient: ipcClient
        )
        
        commandsForAddingRoutes.forEach { $0(dependencies) }
        
        return (ipcRouter, ipcClient)
    }
}

#endif
