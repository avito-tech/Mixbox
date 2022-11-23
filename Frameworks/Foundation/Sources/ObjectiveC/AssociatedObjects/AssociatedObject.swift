#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Wrapper that reduces boilerplate for working with Obj-C associated objects.
//
// Usage:
//
// extension UIScrollView {
//     var myObject: AssociatedObject<MyClass> {
//         return AssociatedObject(
//             container: self,
//             key: "UIScrollView_myObject_77406E178ABD" // Can be anything, should be unique
//         )
//     }
// }
//
// scrollView.myObject.value = MyClass()
// print(scrollView.myObject.value)
//
// See also: AssociatedValue
//
public final class AssociatedObject<T: AnyObject> {
    private let container: NSObject
    private let unsafeRawPointerKey: UnsafeRawPointer
    
    public init(container: NSObject, unsafeRawPointerKey: UnsafeRawPointer) {
        self.container = container
        self.unsafeRawPointerKey = unsafeRawPointerKey
    }
    
    public convenience init(container: NSObject, key: StaticString) {
        self.init(
            container: container,
            unsafeRawPointerKey: UnsafeRawPointer(key.utf8Start)
        )
    }
    
    public var value: T? {
        get {
            return objc_getAssociatedObject(container, unsafeRawPointerKey) as? T
        }
        set {
            objc_setAssociatedObject(
                container,
                unsafeRawPointerKey,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}

#endif
