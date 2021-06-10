#if MIXBOX_ENABLE_IN_APP_SERVICES

extension Optional {
    public func map<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T)
        rethrows
        -> T
    {
        return try map(transform) ?? `default`()
    }
    
    public func flatMap<T>(
        default: @autoclosure () -> T,
        transform: (Wrapped) throws -> T?)
        rethrows
        -> T
    {
        return try flatMap(transform) ?? `default`()
    }
}

#endif
