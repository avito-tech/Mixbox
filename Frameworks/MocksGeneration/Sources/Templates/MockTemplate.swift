import SourceryRuntime

public final class MockTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class Mock\(protocolType.name):
            \(protocolType.name),
            MixboxMocksRuntime.MockType
        {
            let mockManager: MixboxMocksRuntime.MockManager
            
            \(try StubBuilderTemplate(protocolType: protocolType).render().indent())
        
            \(try ExpectationBuilderTemplate(protocolType: protocolType).render().indent())
            
            init(mockManager: MixboxMocksRuntime.MockManager) {
                self.mockManager = mockManager
            }

            convenience init(file: StaticString = #file, line: UInt = #line) {
                self.init(
                    mockManager: MixboxMocksRuntime.MockManagerImpl(
                        fileLine: MixboxFoundation.FileLine(
                            file: file,
                            line: line
                        )
                    )
                )
            }

            \(try ProtocolImplementationTemplate(protocolType: protocolType).render().indent())
        }
        """
    }
}
