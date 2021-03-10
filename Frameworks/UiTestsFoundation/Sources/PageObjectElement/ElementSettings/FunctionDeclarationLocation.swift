import MixboxFoundation

public final class FunctionDeclarationLocation {
    public let fileLine: FileLine
    public let function: String
    
    public init(
        fileLine: FileLine,
        function: String)
    {
        self.fileLine = fileLine
        self.function = function
    }
}
