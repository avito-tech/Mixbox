import SourceryRuntime

public class ProtocolImplementationTemplate {
    private let protocolType: Protocol
    
    public init(protocolType: Protocol) {
        self.protocolType = protocolType
    }
    
    public func render() -> String {
        let methods = protocolType.allMethods.map {
            ProtocolImplementationFunctionTemplate(method: $0).render()
        }
        
        let properties = protocolType.allVariables.map {
            ProtocolImplementationPropertyTemplate(variable: $0).render()
        }
        
        return (properties + methods).joined(separator: "\n\n")
    }
}
