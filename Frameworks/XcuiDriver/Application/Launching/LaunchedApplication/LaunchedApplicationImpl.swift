import MixboxIpc

public final class LaunchedApplicationImpl: LaunchedApplication {
    public let ipcClient: IpcClient?
    public let ipcRouter: IpcRouter?
    
    public init(
        ipcClient: IpcClient?,
        ipcRouter: IpcRouter?)
    {
        self.ipcClient = ipcClient
        self.ipcRouter = ipcRouter
    }
}
