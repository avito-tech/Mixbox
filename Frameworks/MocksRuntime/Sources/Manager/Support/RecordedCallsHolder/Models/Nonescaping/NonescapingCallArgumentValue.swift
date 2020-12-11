import MixboxTestsFoundation

// The only diffrence from `NonEscapingCallArgumentValue` is that `NonEscapingClosureArgumentValue`
// is used instead of `NonEscapingClosureValueReflection`.
//
// See `NonEscapingClosureValue` for more info.
//
// This class can be used to temporarily access non-escaping closures (like calling them).
// If you store nonescaping closures in objects that have lifecycle longer than lifecycle of
// current callstack frame, you will get a crash (assertion failure in Swift standard library).
public enum NonEscapingCallArgumentValue {
    case regular(RegularArgumentValue)
    case escapingClosure(EscapingClosureArgumentValue)
    case optionalEscapingClosure(OptionalEscapingClosureArgumentValue)
    case nonEscapingClosure(NonEscapingClosureArgumentValue)
    
    public func typedNestedValue<T>(type: T.Type = T.self) -> T? {
        switch self {
        case let .regular(nested):
            return nested.value as? T
        case let .escapingClosure(nested):
            return nested.value as? T
        case let .optionalEscapingClosure(nested):
            return nested.value as? T
        case let .nonEscapingClosure(nested):
            return nested.value as? T
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
    
    public func asNonEscapingClosure() -> NonEscapingClosureArgumentValue? {
        switch self {
        case let .nonEscapingClosure(nested):
            return nested
        default:
            return nil
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
