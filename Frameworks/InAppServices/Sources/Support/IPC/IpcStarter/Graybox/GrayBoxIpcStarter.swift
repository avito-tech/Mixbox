#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxIpc

public final class GrayBoxIpcStarter: IpcStarter {
    private let sameProcessIpcClientServer = SameProcessIpcClientServer()
    private let synchronousIpcClientFactory: SynchronousIpcClientFactory
    
    public init(
        synchronousIpcClientFactory: SynchronousIpcClientFactory)
    {
        self.synchronousIpcClientFactory = synchronousIpcClientFactory
    }
    
    public func start(
        commandsForAddingRoutes: [IpcMethodHandlerRegistrationTypeErasedClosure])
        throws
        -> StartedIpc
    {
        let dependencies = IpcMethodHandlerRegistrationDependencies(
            ipcRouter: sameProcessIpcClientServer,
            ipcClient: sameProcessIpcClientServer,
            synchronousIpcClient: synchronousIpcClientFactory.synchronousIpcClient(ipcClient: sameProcessIpcClientServer)
        )
        
        try commandsForAddingRoutes.forEach { command in
            try command(dependencies)
        }
        
        return StartedIpc(
            ipcRouter: sameProcessIpcClientServer,
            ipcClient: sameProcessIpcClientServer
        )
    }
}

#endif
