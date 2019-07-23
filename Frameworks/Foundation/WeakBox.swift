#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class WeakBox<T> where T: AnyObject {
    public private(set) weak var value: T?
    
    public init(_ value: T) {
        self.value = value
    }
}

#endif
