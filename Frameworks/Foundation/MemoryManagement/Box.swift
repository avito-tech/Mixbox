#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class Box<T> {
    public let value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

#endif
