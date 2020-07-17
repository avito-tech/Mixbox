import MixboxIpc
import MixboxInAppServices

// Handy utility for making IpcHandlers for interacting between views and tests
public final class ViewIpc {
    private let ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?
    
    public init(ipcMethodHandlerWithDependenciesRegisterer: IpcMethodHandlerWithDependenciesRegisterer?) {
        self.ipcMethodHandlerWithDependenciesRegisterer = ipcMethodHandlerWithDependenciesRegisterer
    }
    
    public func register<Method: IpcMethod>(
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
