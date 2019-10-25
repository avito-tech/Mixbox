#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

extension IpcClient {
    // Synchronous version
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, Error>
    {
        var result: DataResult<Method.ReturnValue, Error>?
        
        call(method: method, arguments: arguments) { localResult in
            result = localResult
        }
        
        IpcSynchronization.waitWhile { result == nil }
        
        return result ?? .error(ErrorString("noResponse")) // TODO: Better error
    }
    
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
