#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class IpcMethodHandlerRegistrationDependencies {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient? // TODO: Make it not optional after removing SBTUITestTunnel
    public let synchronousIpcClient: SynchronousIpcClient? // TODO: Make it not optional too
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient?,
        synchronousIpcClient: SynchronousIpcClient?)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
        self.synchronousIpcClient = synchronousIpcClient
    }
}

#endif
