#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

extension ErrorString {
    // Allows to map errors without extra code.
    //
    // E.g.:
    //
    // ```
    // let x: ExplicitType
    // do {
    //     let localX = try getX()
    //     x = localX
    // } catch {
    //     throw convertError(error)
    // }
    // use(x)
    // ```
    // =>
    // ```
    // let x = ErrorString.mapError(
    //     body: { try getX() },
    //     transform: { convertError($0) }
    // }
    // use(x)
    // ```
    public static func map<T>(
        body: () throws -> T,
        transform: (Error) -> ErrorString)
        throws
        -> T
    {
        do {
            return try body()
        } catch {
            throw transform(error)
        }
    }
    
    public static func map<T>(
        body: () throws -> T,
        transform: (Error) -> String)
        throws
        -> T
    {
        return try map(body: body) {
            ErrorString($0)
        }
    }
}

#endif
