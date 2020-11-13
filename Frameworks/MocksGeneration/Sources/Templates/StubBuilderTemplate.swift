import SourceryRuntime

public class StubBuilderTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class StubBuilder: AvitoMocks.StubBuilder {
            private let mockManager: AvitoMocks.MockManager

            required init(mockManager: AvitoMocks.MockManager) {
                self.mockManager = mockManager
            }
            
            \(try renderFunctions())
        }
        """
    }
    
    private func renderFunctions() throws -> String {
        try protocolType.methods.map {
            try StubBuilderFunctionTemplate(method: $0).render()
        }.joined(separator: "\n\n")
    }
}
