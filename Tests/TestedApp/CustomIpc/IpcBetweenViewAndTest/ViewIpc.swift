import MixboxIpc

// Handy utility for making IpcHandlers for interacting between views and tests
final class ViewIpc {
    private let ipcRouter: IpcRouter?
    
    init(ipcRouter: IpcRouter?) {
        self.ipcRouter = ipcRouter
    }
    
    func register<Method: IpcMethod>(
        method: Method,
        closure: @escaping ClosureMethodHandler<Method>.Closure)
    {
        ipcRouter?.register(
            methodHandler: ClosureMethodHandler(
                method: method,
                closure: closure
            )
        )
    }
}
