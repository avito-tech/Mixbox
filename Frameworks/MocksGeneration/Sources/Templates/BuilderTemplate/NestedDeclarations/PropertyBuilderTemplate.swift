import SourceryRuntime

public class PropertyBuilderTemplate {
    private let variable: Variable
    private let builderType: String
    
    public init(
        variable: Variable,
        builderType: String)
    {
        self.variable = variable
        self.builderType = builderType
    }
    
    public func render() -> String {
        """
        var \(variable.name): \(returnType) {
            \(getter.indent())
        }
        """
    }
    
    private var returnType: String {
        return "MixboxMocksRuntime.\(variableBuilderName)<\(variable.typeName.validTypeName)>"
    }
    
    private var getter: String {
        """
        \(returnType)(
            variableName:
            \(Snippets.variableNameStringLiteral(variable: variable).indent()),
            mockManager: mockManager
        )
        """
    }
    
    private var variableBuilderName: String {
        variable.isMutable
            ? "\(builderType)MutablePropertyBuilder"
            : "\(builderType)ImmutablePropertyBuilder"
    }
}
