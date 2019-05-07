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
