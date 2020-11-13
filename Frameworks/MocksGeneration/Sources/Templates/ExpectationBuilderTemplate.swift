import SourceryRuntime

public class ExpectationBuilderTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class ExpectationBuilder: AvitoMocks.ExpectationBuilder {
            private let mockManager: AvitoMocks.MockManager
            private let times: AvitoMocks.FunctionalMatcher<UInt>
            private let fileLine: AvitoMocks.FileLine

            required init(
                mockManager: AvitoMocks.MockManager,
                times: AvitoMocks.FunctionalMatcher<UInt>,
                fileLine: AvitoMocks.FileLine)
            {
                self.mockManager = mockManager
                self.times = times
                self.fileLine = fileLine
            }
        
            \(try renderFunctions())
        }
        """
    }
    
    private func renderFunctions() throws -> String {
        try protocolType.methods.map {
            try ExpectationBuilderFunctionTemplate(method: $0).render()
        }.joined(separator: "\n\n")
    }
}
