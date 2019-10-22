#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ThreadUnsafeOnceToken<T>: OnceToken {
    private var value: T?
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        return value != nil
    }
    
    public func executeOnce(_ closure: () throws -> T) rethrows -> T {
        if let value = value {
            return value
        } else {
            let value = try closure()
            self.value = value
            return value
        }
    }
}

#endif
