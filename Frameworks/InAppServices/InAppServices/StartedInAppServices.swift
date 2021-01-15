#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class StartedInAppServices {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
    }
}

#endif
