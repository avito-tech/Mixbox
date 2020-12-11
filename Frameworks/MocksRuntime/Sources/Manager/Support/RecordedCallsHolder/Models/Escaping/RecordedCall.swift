// For remembering what was called and with which arguments.
public final class RecordedCall {
    public let functionIdentifier: FunctionIdentifier
    public let arguments: RecordedCallArguments
    
    public init(
        functionIdentifier: FunctionIdentifier,
        arguments: RecordedCallArguments)
    {
        self.functionIdentifier = functionIdentifier
        self.arguments = arguments
    }
}
