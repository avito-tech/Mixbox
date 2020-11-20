import SourceryRuntime

public class BuilderTemplate {
    private let protocolType: Protocol
    private let builderName: String
    private let functionBuilderName: String
    
    public init(
        protocolType: Protocol,
        builderName: String,
        functionBuilderName: String)
    {
        self.protocolType = protocolType
        self.builderName = builderName
        self.functionBuilderName = functionBuilderName
    }
    
    public func render() throws -> String {
        """
        class \(builderName): MixboxMocksRuntime.\(builderName) {
            private let mockManager: MixboxMocksRuntime.MockManager
            private let fileLine: FileLine
            
            required init(mockManager: MixboxMocksRuntime.MockManager, fileLine: FileLine) {
                self.mockManager = mockManager
                self.fileLine = fileLine
            }
            
            \(try renderFunctions().indent())
        }
        """
    }
    
    private func renderFunctions() throws -> String {
        try protocolType.methods.map {
            let template = FunctionBuilderTemplate(
                method: $0,
                functionBuilderName: functionBuilderName
            )
            
            return try template.render()
        }.joined(separator: "\n\n")
    }
}
