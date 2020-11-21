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
    
    public func render() throws -> String {
        """
        class \(builderName): MixboxMocksRuntime.\(builderName) {
            \(try blocks().indent())
        }
        """
    }
    
    private func blocks() throws -> String {
        let blocks = [header] + properties + (try functions())
        
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
    
    private func functions() throws -> [String] {
        return try protocolType.allMethods.map {
            let template = try FunctionBuilderTemplate(
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
