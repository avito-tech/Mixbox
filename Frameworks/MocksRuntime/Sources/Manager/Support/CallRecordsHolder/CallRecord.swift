// For remembering what was called and with which arguments.
public final class CallRecord {
    public let functionIdentifier: FunctionIdentifier
    public let arguments: Any
    
    public init(functionIdentifier: FunctionIdentifier, arguments: Any) {
        self.functionIdentifier = functionIdentifier
        self.arguments = arguments
    }
}
