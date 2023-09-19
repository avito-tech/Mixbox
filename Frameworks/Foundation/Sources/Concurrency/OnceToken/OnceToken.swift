#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Execute things once.
public protocol OnceToken: AnyObject {
    associatedtype ReturnValue
    
    func wasExecuted() -> Bool
    
    func executeOnce(
        body: () throws -> ReturnValue,
        observer: (Bool, ReturnValue) -> ())
        rethrows
        -> ReturnValue
}

extension OnceToken {
    public func executeOnce(
        body: () throws -> ReturnValue)
        rethrows
        -> ReturnValue
    {
        return try executeOnce(
            body: body,
            observer: { _, _ in }
        )
    }
}

#endif
