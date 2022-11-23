#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc
import MixboxSBTUITestTunnelServer
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
    
    func start(
        commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure])
        throws
        -> StartedIpc
    {
        SBTUITestTunnelServer.takeOff()
        
        let ipcClient: IpcClient? = nil
        
        let dependencies = IpcMethodHandlerRegistrationDependencies(
            ipcRouter: ipcRouter,
            ipcClient: ipcClient,
            synchronousIpcClient: ipcClient.map {
                synchronousIpcClientFactory.synchronousIpcClient(ipcClient: $0)
            }
        )
        
        try commandsForAddingRoutes.forEach { try $0(dependencies) }
        
        return StartedIpc(
            ipcRouter: ipcRouter,
            ipcClient: ipcClient
        )
    }
}

#endif
