// Эквиваленнтно Optional, просто подчеркивает смысл:
// Получение значения недоступно, если .unavailable.
// Наиболее хорошо подчеркивает смысл в ситуации с .available(nil),
// заменяя двойной Optional.
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
