#if MIXBOX_ENABLE_IN_APP_SERVICES

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
