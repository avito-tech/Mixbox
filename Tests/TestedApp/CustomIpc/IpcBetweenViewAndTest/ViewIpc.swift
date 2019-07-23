import MixboxIpc
import MixboxInAppServices

// Handy utility for making IpcHandlers for interacting between views and tests
final class ViewIpc {
    private let ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?
    
    init(ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?) {
        self.ipcMethodHandlerWithDependenciesRegisterer = ipcMethodHandlerWithDependenciesRegisterer
    }
    
    func register<Method: IpcMethod>(
        method: Method,
        closure: @escaping ClosureMethodHandler<Method>.Closure)
    {
        ipcMethodHandlerWithDependenciesRegisterer?.register { _ in
            ClosureMethodHandler(
                method: method,
                closure: closure
            )
        }
    }
}
