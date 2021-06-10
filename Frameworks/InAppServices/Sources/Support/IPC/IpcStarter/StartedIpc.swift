#if MIXBOX_ENABLE_IN_APP_SERVICES

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
