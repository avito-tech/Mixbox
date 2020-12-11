public enum AnyGeneratorDynamicCallableFunctionArgument {
    case closure(AnyGeneratorDynamicCallableClosureArgument)
    case nonClosure(AnyGeneratorDynamicCallableNonClosureArgument)
    
    public func isClosure() -> Bool {
        return asClosure() != nil
    }
    
    public func isNonClosure() -> Bool {
        return asNonClosure() != nil
    }
        
    public func asClosure() -> AnyGeneratorDynamicCallableClosureArgument? {
        switch self {
        case let .closure(nested):
            return nested
        case .nonClosure:
            return nil
        }
    }
    
    public func asNonClosure() -> AnyGeneratorDynamicCallableNonClosureArgument? {
        switch self {
        case let .nonClosure(nested):
            return nested
        case .closure:
            return nil
        }
    }
}
