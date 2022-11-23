#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

extension Optional {
    // TODO: Add `mb_` prefix to avoid name collisions
    public func unwrapOrThrow(
        error: (_ fileLine: FileLine) -> Error,
        file: StaticString = #filePath,
        line: UInt = #line)
        throws
        -> Wrapped
    {
        return try unwrapOrThrow(
            error: error(
                FileLine(
                    file: file,
                    line: line
                )
            )
        )
    }
    
    public func unwrapOrThrow(
        message: (_ fileLine: FileLine) -> String,
        file: StaticString = #filePath,
        line: UInt = #line)
        throws
        -> Wrapped
    {
        return try unwrapOrThrow(
            error: { fileLine in
                ErrorString(message(fileLine))
            },
            file: file,
            line: line
        )
    }
    
    public func unwrapOrThrow(
        message: @autoclosure () -> String)
        throws
        -> Wrapped
    {
        return try unwrapOrThrow(
            error: { ErrorString(message()) }()
        )
    }
    
    public func unwrapOrThrow(
        error: @autoclosure () -> Error)
        throws
        -> Wrapped
    {
        if let unwrapped = self {
            return unwrapped
        } else {
            throw error()
        }
    }
    
    public func unwrapOrThrow(
        file: StaticString = #filePath,
        line: UInt = #line)
        throws
        -> Wrapped
    {
        return try unwrapOrThrow(
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
        return "Found nil when unwrapping optional at \(fileLine.file):\(fileLine.line)"
    }
}

#endif
