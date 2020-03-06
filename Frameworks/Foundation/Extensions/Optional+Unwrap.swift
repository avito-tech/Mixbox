#if MIXBOX_ENABLE_IN_APP_SERVICES

extension Optional {
    public func unwrapOrThrow(
        error: (_ fileLine: FileLine) -> Error,
        file: StaticString = #file,
        line: UInt = #line)
        throws -> Wrapped
    {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw error(FileLine(file: file, line: line))
        }
    }
    
    public func unwrapOrThrow(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        return try unwrapOrThrow(
            error: { ErrorString("Found nil when unwrapping optional at \($0.file):\($0.line)") },
            file: file,
            line: line
        )
    }
    
    public func unwrapOrThrow(
        error: @autoclosure () -> Error)
        throws -> Wrapped
    {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw error()
        }
    }
}

#endif
