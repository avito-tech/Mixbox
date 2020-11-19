import SourceryRuntime

public final class MockTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        """
        class Mock\(protocolType.name):
            MixboxMocksRuntime.BaseMock,
            \(protocolType.name),
            MixboxMocksRuntime.Mock
        {
            \(try StubBuilderTemplate(protocolType: protocolType).render().indent())
        
            \(try ExpectationBuilderTemplate(protocolType: protocolType).render().indent())

            \(try ProtocolImplementationTemplate(protocolType: protocolType).render().indent())
        }
        """
    }
}
