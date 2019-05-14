import MixboxFoundation

extension IpcClient {
    // Synchronous version
    public func call<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments)
        -> DataResult<Method.ReturnValue, IpcClientError>
    {
        var result: DataResult<Method.ReturnValue, IpcClientError>?
        
        call(method: method, arguments: arguments) { localResult in
            result = localResult
        }
        
        // TODO: Use a specific tool for non-blocking (kind of) waiting in the current thread.
        var delayIntervals = [0.05, 0.1, 0.2, 0.4, 1]
        while result == nil {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: delayIntervals[0]))
            if delayIntervals.count > 1 {
                delayIntervals = Array(delayIntervals.dropFirst())
            }
        }
        
        return result ?? .error(.noResponse)
    }
    
    // Synchronous version for methods without arguments
    public func call<Method: IpcMethod>(
        method: Method)
        -> DataResult<Method.ReturnValue, IpcClientError>
        where Method.Arguments == IpcVoid
    {
        return call(method: method, arguments: IpcVoid())
    }
}
