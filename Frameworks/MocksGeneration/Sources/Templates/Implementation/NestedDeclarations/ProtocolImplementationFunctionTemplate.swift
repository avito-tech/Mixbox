import SourceryRuntime

public class ProtocolImplementationFunctionTemplate {
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        """
        func \(method.callName)\(try genericParameterClauseString())\(methodArguments)\(returnClause) {
            \(body.indent())
        }
        """
    }
    
    private func genericParameterClauseString() throws -> String {
        let genericNames = try method.genericParameterClause().map(default: []) { genericParameterClause in
            genericParameterClause.genericParameters.map { genericParameter in
                genericParameter.name
            }
        }
        
        return genericNames.render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "<\($0)>" }
        )
    }
    
    private var body: String {
        Snippets.withoutActuallyEscaping(
            parameters: method.parameters,
            argumentName: Snippets.argumentName,
            returnType: returnType,
            body: bodyWithEscapingClosures
        )
    }
    
    private var bodyWithEscapingClosures: String {
        """
        return getMockManager().call(
            functionIdentifier:
            \(Snippets.functionIdentifier(method: method).indent(level: 1)),
            arguments: \(tupledArguments)
        )
        """
    }
    
    private var methodArguments: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, parameter in
                let labeledArgument = Snippets.labeledArgument(
                    label: parameter.argumentLabel,
                    name: Snippets.argumentName(index: index)
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
                Snippets.argumentName(index: index)
            }
        )
    }
    
    private var returnClause: String {
        if method.returnTypeName.isVoid {
            return ""
        }
        
        return " -> \(returnType)"
    }
    
    private var returnType: String {
        return method.returnTypeName.validTypeName
    }
}
