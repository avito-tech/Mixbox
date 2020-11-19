#if MIXBOX_ENABLE_IN_APP_SERVICES

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
