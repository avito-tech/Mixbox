#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class IpcMethodHandlerRegistrationDependencies {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient
    public let synchronousIpcClient: SynchronousIpcClient
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient,
        synchronousIpcClient: SynchronousIpcClient)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
        self.synchronousIpcClient = synchronousIpcClient
    }
}

#endif
