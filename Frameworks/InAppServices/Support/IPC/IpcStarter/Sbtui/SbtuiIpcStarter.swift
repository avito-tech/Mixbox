#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc
import SBTUITestTunnel
import MixboxIpcSbtuiHost

final class SbtuiIpcStarter: IpcStarter {
    private let ipcRouter: SbtuiIpcRouter
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    
    // reregisterMethodHandlersAutomatically == true disables asserion if method is registered twice. not recommended.
    init(
        reregisterMethodHandlersAutomatically: Bool,
        synchronousIpcClientFactory: SynchronousIpcClientFactory)
    {
        self.ipcRouter = SbtuiIpcRouter(
            reregisterMethodHandlersAutomatically: reregisterMethodHandlersAutomatically
        )
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
    }
    
    func start(commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure]) throws -> (IpcRouter, IpcClient?) {
        SBTUITestTunnelServer.takeOff()
        
        let ipcClient: IpcClient? = nil
        
        let dependencies = IpcMethodHandlerRegistrationDependencies(
            ipcRouter: ipcRouter,
            ipcClient: ipcClient,
            synchronousIpcClient: ipcClient.map {
                synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0)
            }
        )
        
        commandsForAddingRoutes.forEach { $0(dependencies) }
        
        return (ipcRouter, ipcClient)
    }
}

#endif
