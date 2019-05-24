import MixboxIpc
import MixboxFoundation

// TBD: Handle missing IPC properly (e.g. for third party apps)
public final class AlwaysFailingIpcClient: IpcClient {
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
    {
        completion(.error(IpcClientError.noResponse))
    }
}
