import MixboxTestsFoundation

public enum RecordedCallArgumentValue {
    case regular(RegularArgumentValue)
    case escapingClosure(EscapingClosureArgumentValue)
    case optionalEscapingClosure(OptionalEscapingClosureArgumentValue)
    case nonEscapingClosure // value can't be stored
    
    // Filters out `nonEscapingClosure` case (those can't be stored)
    public func typedNestedValue<T>(type: T.Type = T.self) -> T? {
        switch self {
        case let .regular(nested):
            return nested.value as? T
        case let .escapingClosure(nested):
            return nested.value as? T
        case let .optionalEscapingClosure(nested):
            return nested.value as? T
        case .nonEscapingClosure:
            return nil
        }
    }
    
    public func asEscapingClosure() -> EscapingClosureArgumentValue? {
        switch self {
        case let .escapingClosure(nested):
            return nested
        default:
            return nil
        }
    }
    
    public func asOptionalEscapingClosure() -> OptionalEscapingClosureArgumentValue? {
        switch self {
        case let .optionalEscapingClosure(nested):
            return nested
        default:
            return nil
        }
    }
    
    public func isNonEscapingClosure() -> Bool {
        switch self {
        case .nonEscapingClosure:
            return true
        default:
            return false
        }
    }
    
    public func asRegular() -> RegularArgumentValue? {
        switch self {
        case let .regular(nested):
            return nested
        default:
            return nil
        }
    }
}
