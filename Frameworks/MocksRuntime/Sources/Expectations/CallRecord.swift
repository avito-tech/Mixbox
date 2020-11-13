// For remembering what was called and with which arguments.
public final class CallRecord {
    public let functionId: String
    public let arguments: Any
    
    public init(functionId: String, arguments: Any) {
        self.functionId = functionId
        self.arguments = arguments
    }
}
