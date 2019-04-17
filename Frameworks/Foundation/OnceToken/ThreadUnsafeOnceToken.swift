public final class ThreadUnsafeOnceToken: OnceToken {
    private var wasExecutedValue = false
    
    public init() {
    }
    
    public func wasExecuted() -> Bool {
        return wasExecutedValue
    }
    
    public func executeOnce(_ closure: () throws -> ()) rethrows {
        if !wasExecutedValue {
            try closure()
            wasExecutedValue = true
        }
    }
}
