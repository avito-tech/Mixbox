#if MIXBOX_ENABLE_IN_APP_SERVICES

// Like ErrorString from MixboxFoundation, but this module is not linked with MixboxFoundation.
public final class DiError: Error, CustomStringConvertible {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public var description: String {
        return value
    }
}

#endif
