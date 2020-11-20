import SourceryRuntime

public class BuilderTemplate {
    private let protocolType: Protocol
    private let builderType: String
    
    public init(
        protocolType: Protocol,
        builderType: String)
    {
        self.protocolType = protocolType
        self.builderType = builderType
    }
    
    public func render() -> String {
        """
        class \(builderName): MixboxMocksRuntime.\(builderName) {
            \(blocks.indent())
        }
        """
    }
    
    private var blocks: String {
        let blocks = [header] + properties + functions
        
        return blocks.joined(separator: "\n\n")
    }
    
    private var header: String {
        """
        private let mockManager: MixboxMocksRuntime.MockManager
        private let fileLine: FileLine
        
        required init(mockManager: MixboxMocksRuntime.MockManager, fileLine: FileLine) {
            self.mockManager = mockManager
            self.fileLine = fileLine
        }
        """
    }
    
    private var properties: [String] {
        return protocolType.allVariables.map {
            let template = PropertyBuilderTemplate(
                variable: $0,
                builderType: builderType
            )
            
            return template.render()
        }
    }
    
    private var functions: [String] {
        return protocolType.allMethods.map {
            let template = FunctionBuilderTemplate(
                method: $0,
                builderType: builderType
            )
            
            return template.render()
        }
    }
    
    private var builderName: String {
        "\(builderType)Builder"
    }
}
