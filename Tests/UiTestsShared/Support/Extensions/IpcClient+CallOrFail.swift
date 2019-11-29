import MixboxIpc
import MixboxTestsFoundation
import MixboxFoundation

extension IpcClient {
    func callOrFail<Method: IpcMethod>(
        method: Method,
        arguments: Method.Arguments,
        file: StaticString = #file,
        line: UInt = #line)
        -> Method.ReturnValue
    {
        return failOnThrow(file: file, line: line) {
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
        return failOnThrow(file: file, line: line) {
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
        _ = failOnThrow(file: file, line: line) {
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
        _ = failOnThrow(file: file, line: line) {
            try callOrThrow(
                method: method,
                arguments: arguments
            )
        }
    }
    
    private func failOnThrow<T>(
        file: StaticString,
        line: UInt,
        body: () throws -> (T))
        -> T
    {
        do {
            return try body()
        } catch {
            UnavoidableFailure.fail(
                "\(error)",
                file: file,
                line: line
            )
        }
    }
}
