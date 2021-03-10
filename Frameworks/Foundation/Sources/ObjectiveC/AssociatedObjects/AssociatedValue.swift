#if MIXBOX_ENABLE_IN_APP_SERVICES

// Like AssociatedObject, but for structs (like CGRect) or primitives (like Int)
public final class AssociatedValue<T> {
    private let associatedObject: AssociatedObject<Box<T>>
    private let defaultValue: T
    
    public init(container: NSObject, key: StaticString, defaultValue: T) {
        self.associatedObject = AssociatedObject(container: container, key: key)
        self.defaultValue = defaultValue
    }
    
    public var value: T {
        get {
            return associatedObject.value?.value ?? defaultValue
        }
        set {
            associatedObject.value = Box(newValue)
        }
    }
}

#endif
