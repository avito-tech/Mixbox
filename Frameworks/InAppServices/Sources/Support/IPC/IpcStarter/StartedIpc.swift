#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxIpc

// TODO: IpcClient should not be nil
// (lack of bidirectional IPC is a SBTUITestTunnel limitation)
public final class StartedIpc {
    public let ipcRouter: IpcRouter
    public let ipcClient: IpcClient?
    
    public init(
        ipcRouter: IpcRouter,
        ipcClient: IpcClient?)
    {
        self.ipcRouter = ipcRouter
        self.ipcClient = ipcClient
    }
}

#endif
