import MixboxIpc
import MixboxTestsFoundation
import MixboxFoundation

extension SynchronousIpcClient {
    func callOrFail<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        file: StaticString = #file,
        line: UInt = #line)
        -> Method.ReturnValue
    {
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try callOrThrow(
                method: method,
                arguments: arguments
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
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try callOrThrow(
                method: method,
                arguments: IpcVoid()
            )
        }
    }
    
    // Synchronous version for methods without arguments and return value
    func callOrFail<Method: IpcMethod>(
        method: Method,
        file: StaticString = #file,
        line: UInt = #line)
        where
        Method.Arguments == IpcVoid,
        Method.ReturnValue == IpcVoid
    {
        _ = UnavoidableFailure.doOrFail(file: file, line: line) {
            try callOrThrow(
                method: method,
                arguments: IpcVoid()
            )
        }
    }
    
    // Synchronous version for methods without return value
    func callOrFail<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        file: StaticString = #file,
        line: UInt = #line)
        where
        Method.ReturnValue == IpcVoid
    {
        _ = UnavoidableFailure.doOrFail(file: file, line: line) {
            try callOrThrow(
                method: method,
                arguments: arguments
            )
        }
    }
}
