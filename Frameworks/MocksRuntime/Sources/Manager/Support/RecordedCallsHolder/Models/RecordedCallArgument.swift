import MixboxTestsFoundation

public enum RecordedCallArgument {
    case regular(value: Any)
    case escapingClosure(value: Any, argumentTypes: [Any.Type], returnValueType: Any.Type)
    case optionalEscapingClosure(value: Any?, argumentTypes: [Any.Type], returnValueType: Any.Type)
    case nonEscapingClosure(type: Any.Type)
    
    // Filters out `nonEscapingClosure` case (those can't be stored)
    public func typedNestedValue<T>(type: T.Type = T.self) -> T? {
        switch self {
        case let .regular(value),
             let .escapingClosure(value, _, _):
            return value as? T
        case let .optionalEscapingClosure(value, _, _):
            return value as? T
        case .nonEscapingClosure:
            return nil
        }
    }
    
    public func asEscapingClosure() -> Any? {
        switch self {
        case let .escapingClosure(value, _, _):
            return value
        default:
            return nil
        }
    }
    
    public func asOptionalEscapingClosure() -> Any? {
        switch self {
        case let .optionalEscapingClosure(value, _, _):
            return value
        default:
            return nil
        }
    }
    
    public func asNonEscapingClosureType() -> Any.Type? {
        switch self {
        case let .nonEscapingClosure(value):
            return value
        default:
            return nil
        }
    }
    
    public func asTypedRegular<T>(type: T.Type = T.self) -> T? {
        return asRegular() as? T
    }
    
    public func asRegular() -> Any? {
        switch self {
        case let .regular(value):
            return value
        default:
            return nil
        }
    }
}
