#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class IpcMethodHandlerRegistrationDependencies {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient? // TODO: Make it not optional after removing SBTUITestTunnel
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient?)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
    }
}

#endif
