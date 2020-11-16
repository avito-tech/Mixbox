import SourceryRuntime
import MixboxFoundation

public class ExpectationBuilderTemplate {
    private let protocolType: SourceryRuntime.`Protocol`
    
    public init(protocolType: SourceryRuntime.`Protocol`) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class ExpectationBuilder: MixboxMocksRuntime.ExpectationBuilder {
            private let mockManager: MixboxMocksRuntime.MockManager
            private let times: MixboxMocksRuntime.FunctionalMatcher<Int>
            private let fileLine: MixboxFoundation.FileLine

            required init(
                mockManager: MixboxMocksRuntime.MockManager,
                times: MixboxMocksRuntime.FunctionalMatcher<Int>,
                fileLine: MixboxFoundation.FileLine)
            {
                self.mockManager = mockManager
                self.times = times
                self.fileLine = fileLine
            }
        
            \(try renderFunctions().indent())
        }
        """
    }
    
    private func renderFunctions() throws -> String {
        try protocolType.methods.map {
            try ExpectationBuilderFunctionTemplate(method: $0).render()
        }.joined(separator: "\n\n")
    }
}
