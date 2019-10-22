#if MIXBOX_ENABLE_IN_APP_SERVICES

// Execute things once.
public protocol OnceToken: class {
    associatedtype ReturnValue
    
    func wasExecuted() -> Bool
    
    func executeOnce(
        _ closure: () throws -> ReturnValue)
        rethrows
        -> ReturnValue
}

#endif
