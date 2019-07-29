import MixboxIpc

public protocol IpcRouterProvider {
    var ipcRouter: IpcRouter? { get }
}
