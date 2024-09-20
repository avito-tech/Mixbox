#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

import Foundation

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
