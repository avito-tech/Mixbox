#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ThreadSafeOnceToken<T>: OnceToken {
    private let semaphore = DispatchSemaphore(value: 1)
    private var value: T?
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        if let value = value {
            return true
        } else {
            semaphore.wait()
            defer {
                semaphore.signal()
            }
            return value != nil
        }
    }
    
    public func executeOnce(_ closure: () throws -> T) rethrows -> T {
        if let value = value {
            return value
        } else {
            semaphore.wait()
            
            if let value = value {
                defer {
                    semaphore.signal()
                }
                return value
            } else {
                let value = try closure()
                self.value = value
                semaphore.signal()
                return value
            }
        }
    }
}

#endif
