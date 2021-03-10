import MixboxFoundation

extension Optional {
    public func unwrapOrFail(
        error: (_ fileLine: FileLine) -> Error,
        file: StaticString = #file,
        line: UInt = #line)
        -> Wrapped
    {
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try unwrapOrThrow(
                error: error,
                file: file,
                line: line
            )
        }
    }
    
    public func unwrapOrFail(
        message: (_ fileLine: FileLine) -> String,
        file: StaticString = #file,
        line: UInt = #line)
        -> Wrapped
    {
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try unwrapOrThrow(
                message: message,
                file: file,
                line: line
            )
        }
    }
    
    public func unwrapOrFail(
        message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt = #line)
        -> Wrapped
    {
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try unwrapOrThrow(
                message: message()
            )
        }
    }
    
    public func unwrapOrFail(
        error: @autoclosure () -> Error,
        file: StaticString = #file,
        line: UInt = #line)
        -> Wrapped
    {
        return UnavoidableFailure.doOrFail(file: file, line: line) {
            try unwrapOrThrow(
                error: error()
            )
        }
    }
    
    public func unwrapOrFail(
        file: StaticString = #file,
        line: UInt = #line)
        -> Wrapped
    {
        return unwrapOrFail(
            error: Self.defaultError,
            file: file,
            line: line
        )
    }
    
    private static func defaultError(
        fileLine: FileLine)
        -> Error
    {
        return ErrorString(
            defaultMessage(
                fileLine: fileLine
            )
        )
    }
    
    private static func defaultMessage(
        fileLine: FileLine)
        -> String
    {
        return "Failed to unwrap \(type(of: self)), value is nil, which is not expected, \(fileLine.file):\(fileLine.line)"
    }
}
