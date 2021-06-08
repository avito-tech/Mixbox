import MixboxIpc

public protocol LaunchedApplication: AnyObject {
    var ipcClient: IpcClient? { get }
    var ipcRouter: IpcRouter? { get }
}
