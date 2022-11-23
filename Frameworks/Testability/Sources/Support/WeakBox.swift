// NOTE: Was copypasted from MixboxFoundation. Was made internal.
//       This is because MixboxTestability is not linked with MixboxFoundation.

#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

final class WeakBox<T> where T: AnyObject {
    private(set) weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

extension WeakBox: Equatable where T: Equatable {
    static func ==(lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension WeakBox: Hashable where T: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

#endif
