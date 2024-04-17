#if MIXBOX_ENABLE_FRAMEWORK_FOUNDATION && MIXBOX_DISABLE_FRAMEWORK_FOUNDATION
#error("Foundation is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_FOUNDATION || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_FOUNDATION)
// The compilation is disabled
#else

// Equivalent to Optional, but emphasizes the meaning:
// the value can not be get if `.unavailable`. So, there is a difference between "view doesn't contain something" and
// "view can not contain something". E.g. difference between `.unavailable` and `.available(nil)`. So it matters if
// there is a double optional.
public enum OptionalAvailability<T> {
    case available(T)
    case unavailable

    public init(_ value: T?) {
        switch value {
        case .some(let value):
            self = .available(value)
        case .none:
            self = .unavailable
        }
    }

    public var valueIfAvailable: T? {
        switch self {
        case .available(let value):
            return value
        case .unavailable:
            return nil
        }
    }
}

extension OptionalAvailability: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .available(value):
            return String(reflecting: value)

        case .unavailable:
            return "unavailable"
        }
    }
}

extension OptionalAvailability: Equatable where T: Equatable {
    public static func ==(l: OptionalAvailability<T>, r: OptionalAvailability<T>) -> Bool {
        switch (l, r) {
        case let (.available(a), .available(b)):
            return a == b
        case (.unavailable, .unavailable):
            return true
        default:
            return false
        }
    }
}

extension OptionalAvailability: Codable where T: Codable { }

#endif
