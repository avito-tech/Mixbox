import SourceryRuntime

public class ProtocolImplementationFunctionTemplate {
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        """
        func \(method.callName)\(methodArguments)\(returnClause) {
            return getMockManager().call(
                functionIdentifier:
                \"\"\"
                \(method.name)
                \"\"\",
                arguments: \(tupledArguments)
            )
        }
        """
    }
    
    private var methodArguments: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, parameter in
                let labeledArgument = CodeGenerationUtils.labeledArgument(
                    label: parameter.argumentLabel,
                    name: argumentName(index: index)
                )
                
                let type = parameter.typeName.name
                
                return "\(labeledArgument): \(type)"
            }
        )
    }
    
    private var tupledArguments: String {
        return method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, _ in
                argumentName(index: index)
            }
        )
    }
    
    private func argumentName(index: Int) -> String {
        return "argument\(index)"
    }
    
    private var returnClause: String {
        if method.returnTypeName.isVoid {
            return ""
        }
        
        return " -> \(method.returnTypeName.name)"
    }
}
