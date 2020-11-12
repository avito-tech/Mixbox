// For remembering what was called and with which arguments.
public final class CallRecord {
    public let functionId: String
    public let args: Any
    
    public init(functionId: String, args: Any) {
        self.functionId = functionId
        self.args = args
    }
}
