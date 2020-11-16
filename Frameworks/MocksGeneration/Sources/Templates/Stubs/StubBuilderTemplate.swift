import SourceryRuntime

public class StubBuilderTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class StubBuilder: MixboxMocksRuntime.StubBuilder {
            private let mockManager: MixboxMocksRuntime.MockManager

            required init(mockManager: MixboxMocksRuntime.MockManager) {
                self.mockManager = mockManager
            }
            
            \(try renderFunctions().indent())
        }
        """
    }
    
    private func renderFunctions() throws -> String {
        try protocolType.methods.map {
            try StubBuilderFunctionTemplate(method: $0).render()
        }.joined(separator: "\n\n")
    }
}
