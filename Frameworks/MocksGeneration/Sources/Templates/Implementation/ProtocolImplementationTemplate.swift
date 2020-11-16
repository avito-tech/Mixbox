import SourceryRuntime

public class ProtocolImplementationTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() throws -> String {
        try protocolType.methods.map {
            try ProtocolImplementationFunctionTemplate(method: $0).render()
        }.joined(separator: "\n\n")
    }
}
