import SourceryRuntime

public final class MockTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() -> String {
        let stubbingBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderType: "Stubbing"
        )
        
        let verifcationBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderType: "Verification"
        )
        
        return """
        class Mock\(protocolType.name):
            MixboxMocksRuntime.BaseMock,
            \(protocolType.name),
            MixboxMocksRuntime.Mock
        {
            \(stubbingBuilderTemplate.render().indent())
        
            \(verifcationBuilderTemplate.render().indent())

            \(ProtocolImplementationTemplate(protocolType: protocolType).render().indent())
        }
        """
    }
}
