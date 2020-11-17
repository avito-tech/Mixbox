import SourceryRuntime

public class ProtocolImplementationFunctionTemplate {
    private let method: Method
    
    public init(method: Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        """
        func \(method.callName)\(methodArguments)\(returnClause) {
            return mockManager.call(
                functionId:
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
                let label = parameter.argumentLabel ?? "_"
                let name = argumentName(index: index)
                let type = parameter.typeName.name
                
                return "\(label) \(name): \(type)"
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
        return " -> \(method.returnTypeName.name)"
    }
}
