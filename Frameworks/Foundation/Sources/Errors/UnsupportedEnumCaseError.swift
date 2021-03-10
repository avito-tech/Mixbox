#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class UnsupportedEnumCaseError: Error, CustomStringConvertible {
    private let message: String
    
    public init<T>(_ enumCaseValue: T) {
        message = "Unsupported case of \(T.self): \(enumCaseValue)"
    }
    
    public var description: String {
        return message
    }
}

#endif
