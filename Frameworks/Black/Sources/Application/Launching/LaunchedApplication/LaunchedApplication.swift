import MixboxIpc

public protocol LaunchedApplication: class {
    var ipcClient: IpcClient? { get }
    var ipcRouter: IpcRouter? { get }
}
