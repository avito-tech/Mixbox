import MixboxIpc
import MixboxFoundation

public final class SameProcessIpcClient: IpcClient {
    public init() {
    }
    
    public func call<Method>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
        where Method : IpcMethod
    {
        preconditionFailure("Not implemented")
    }
}
