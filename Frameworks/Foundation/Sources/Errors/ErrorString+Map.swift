#if MIXBOX_ENABLE_IN_APP_SERVICES

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
