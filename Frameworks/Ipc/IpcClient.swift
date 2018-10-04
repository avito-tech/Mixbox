import MixboxFoundation

public enum IpcClientError {
    case customError(String)
    case noResponse
    case encodingError
    case decodingError
}

public protocol IpcClient: class {
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        completion: @escaping (DataResult<Method.ReturnValue, IpcClientError>) -> ())
}

public extension IpcClient {
    // Synchronous version
    func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, IpcClientError>
    {
        var result: DataResult<Method.ReturnValue, IpcClientError>? = nil
        
        call(method: method, arguments: arguments) { localResult in
            result = localResult
        }
        
        // TODO: Use a specific tool for non-blocking (kind of) waiting in the current thread.
        while result == nil {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        return result ?? .error(.noResponse)
    }
    
    // Synchronous version for methods without arguments
    func call<Method: IpcMethod>(
        method: Method)
        -> DataResult<Method.ReturnValue, IpcClientError>
        where Method.Arguments == IpcVoid
    {
        return call(method: method, arguments: IpcVoid())
    }
}
