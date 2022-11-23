#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class ThreadSafeOnceToken<T>: OnceToken {
    private let semaphore = DispatchSemaphore(value: 1)
    private var value: T?
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        if value != nil {
            return true
        } else {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            return value != nil
        }
    }
    
    public func executeOnce(
        body: () throws -> T,
        observer: (Bool, T) -> ())
        rethrows
        -> T
    {
        if let value = value {
            return value
        } else {
            semaphore.wait()
            
            if let value = value {
                semaphore.signal()
                
                observer(false, value)
                
                return value
            } else {
                let value = try body()
                self.value = value
                
                semaphore.signal()
                
                observer(true, value)
                
                return value
            }
        }
    }
}

#endif
