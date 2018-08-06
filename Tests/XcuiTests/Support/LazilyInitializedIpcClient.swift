import MixboxFoundation
import MixboxIpc

public final class LazilyInitializedIpcClient: IpcClient {
    public var ipcClient: IpcClient?
    
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
    {
        if let ipcClient = ipcClient {
            ipcClient.call(
                method: method,
                arguments: arguments,
                completion: completion
            )
        } else {
            completion(.error(.customError("ipcClient was not set")))
        }
    }
}
