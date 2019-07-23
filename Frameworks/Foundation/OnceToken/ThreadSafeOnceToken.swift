#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ThreadSafeOnceToken: OnceToken {
    private let semaphore = DispatchSemaphore(value: 1)
    private var wasExecutedUnsafeValue = false
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        if wasExecutedUnsafeValue {
            return true
        } else {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            return wasExecutedUnsafeValue
        }
    }
    
    public func executeOnce(_ closure: () throws -> ()) rethrows {
        if !wasExecutedUnsafeValue {
            semaphore.wait()
            
            if !wasExecutedUnsafeValue {
                wasExecutedUnsafeValue = true
                semaphore.signal()
                try closure()
            } else {
                semaphore.signal()
            }
        }
    }
}

#endif
