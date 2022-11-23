#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

public final class WeakBox<T> where T: AnyObject {
    public private(set) weak var value: T?
    
    public init(_ value: T) {
        self.value = value
    }
}

extension WeakBox: Equatable where T: Equatable {
    public static func ==(lhs: WeakBox<T>, rhs: WeakBox<T>) -> Bool {
        return lhs.value == rhs.value
    }
}

extension WeakBox: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

#endif
