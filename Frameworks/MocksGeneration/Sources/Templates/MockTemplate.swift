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
            AvitoMocks.Mock
        {
            let mockManager: AvitoMocks.MockManager
            
            \(try StubBuilderTemplate(protocolType: protocolType).render())
        
            \(try ExpectationBuilderTemplate(protocolType: protocolType).render())
        
            \(try StubBuilderTemplate(protocolType: protocolType).render())
            

            init(mockManager: AvitoMocks.MockManager) {
                self.mockManager = mockManager
            }

            convenience init(file: StaticString = #file, line: UInt = #line) {
                self.init(
                    mockManager: AvitoMocks.AvitoMocks.ockManager(
                        fileLine: AvitoMocks.FileLine(
                            file: file,
                            line: line
                        )
                    )
                )
            }

            /* TBD: Functions of the mock */
        }
        """
    }
}
