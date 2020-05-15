#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class MutableBox<T> {
    public var value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

#endif
