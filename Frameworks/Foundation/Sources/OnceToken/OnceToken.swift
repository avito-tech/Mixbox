#if MIXBOX_ENABLE_IN_APP_SERVICES

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
