import MixboxIpc

public protocol LaunchedApplication {
    var ipcClient: IpcClient? { get }
    var ipcRouter: IpcRouter? { get }
}
