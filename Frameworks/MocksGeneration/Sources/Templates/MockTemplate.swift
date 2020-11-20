import SourceryRuntime

public final class MockTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        let stubbingBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderName: "StubbingBuilder",
            functionBuilderName: "StubbingFunctionBuilder"
        )
        
        let verifcationBuilderTemplate = BuilderTemplate(
            protocolType: protocolType,
            builderName: "VerificationBuilder",
            functionBuilderName: "VerificationFunctionBuilder"
        )
        
        return """
        class Mock\(protocolType.name):
            MixboxMocksRuntime.BaseMock,
            \(protocolType.name),
            MixboxMocksRuntime.Mock
        {
            \(try stubbingBuilderTemplate.render().indent())
        
            \(try verifcationBuilderTemplate.render().indent())

            \(try ProtocolImplementationTemplate(protocolType: protocolType).render().indent())
        }
        """
    }
}
