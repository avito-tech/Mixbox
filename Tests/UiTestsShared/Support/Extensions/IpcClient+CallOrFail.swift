import MixboxIpc
import MixboxTestsFoundation
import MixboxFoundation

extension IpcClient {
    // Asyncronous version
    func callOrFail<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        file: StaticString = #file,
        line: UInt = #line,
        completion: @escaping (Method.ReturnValue) -> ())
    {
        call(
            method: method,
            arguments: arguments,
            completion: { result in
                switch result {
                case .data(let data):
                    completion(data)
                case .error(let error):
                    UnavoidableFailure.fail(
                        failureMessage(method: method, arguments: arguments, reason: "\(error)"),
                        file: file,
                        line: line
                    )
                }
            }
        )
    }
    
    // Synchronous version
    func callOrFail<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        file: StaticString = #file,
        line: UInt = #line)
        -> Method.ReturnValue
    {
        var result: Method.ReturnValue?
        
        callOrFail(
            method: method,
            arguments: arguments,
            file: file,
            line: line,
            completion: { localResult in
                result = localResult
            }
        )
        
        // TODO: Use a specific tool for non-blocking (kind of) waiting in the current thread.
        while result == nil {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        if let result = result {
            return result
        } else {
            UnavoidableFailure.fail(
                failureMessage(method: method, arguments: arguments, reason: "result is nil"),
                file: file,
                line: line
            )
        }
    }
    
    // Synchronous version for methods without arguments
    func callOrFail<Method: IpcMethod>(
        method: Method,
        file: StaticString = #file,
        line: UInt = #line)
        -> Method.ReturnValue
        where Method.Arguments == IpcVoid
    {
        return callOrFail(
            method: method,
            arguments: IpcVoid(),
            file: file,
            line: line
        )
    }
}

private func failureMessage<Method: IpcMethod>(
    method: Method,
    arguments: Method.Arguments,
    reason: String)
    -> String
{
    return "Failed calling method \(method) with arguments \(arguments) by IpcClient: \(reason)"
}
