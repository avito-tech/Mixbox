#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class ThreadUnsafeOnceToken<T>: OnceToken {
    private var value: T?
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        return value != nil
    }
    
    public func executeOnce(
        body: () throws -> T,
        observer: (Bool, T) -> ())
        rethrows
        -> T
    {
        if let value = value {
            observer(false, value)
            
            return value
        } else {
            let value = try body()
            self.value = value
            
            observer(true, value)
            
            return value
        }
    }
}

#endif
