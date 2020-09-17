// NOTE: Was copypasted from MixboxFoundation. Was made internal.
//       This is because MixboxTestability is not linked with MixboxFoundation.

#if MIXBOX_ENABLE_IN_APP_SERVICES

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
