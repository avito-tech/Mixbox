import SourceryRuntime

extension MethodParameter {
    // NOTE: Will not work for typealiases if they can't be resolved
    public var isNonEscapingClosure: Bool {
        return typeName.isReallyClosure && !hasEscapingAttribute
    }
    
    // NOTE: Will not work for typealiases if they can't be resolved
    public var isEscapingClosure: Bool {
        return typeName.isReallyClosure && hasEscapingAttribute
    }
    
    public var hasEscapingAttribute: Bool {
        typeName.attributes[AttributeName.escaping.rawValue] != nil
    }
}
