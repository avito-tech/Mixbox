import SourceryRuntime

extension MethodParameter {
    public var isNonEscapingClosure: Bool {
        return isClosure && !hasEscapingAttribute
    }
    
    private var hasEscapingAttribute: Bool {
        typeName.attributes[AttributeName.escaping.rawValue] != nil
    }
}
