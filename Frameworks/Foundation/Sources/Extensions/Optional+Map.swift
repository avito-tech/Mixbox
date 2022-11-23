#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

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
