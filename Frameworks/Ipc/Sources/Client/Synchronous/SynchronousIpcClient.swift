#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public protocol SynchronousIpcClient {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, Error>
}

extension SynchronousIpcClient {
    // Synchronous version for methods without arguments
    public func call<Method: IpcMethod>(
        method: Method)
        -> DataResult<Method.ReturnValue, Error>
        where Method.Arguments == IpcVoid
    {
        return call(method: method, arguments: IpcVoid())
    }
}

#endif
