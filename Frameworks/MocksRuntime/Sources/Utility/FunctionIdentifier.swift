public typealias FunctionIdentifier = String

public enum VariableFunctionIdentifierType {
    case get
    case set
}

public final class FunctionIdentifierFactory {
    private init() {
    }
    
    public static func variableFunctionIdentifier(
        variableName: String,
        type: VariableFunctionIdentifierType)
        -> String
    {
        switch type {
        case .get:
            return "get/\(variableName)"
        case .set:
            return "set/\(variableName)"
        }
    }
}
