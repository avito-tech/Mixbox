import SourceryRuntime

public class FunctionBuilderTemplate {
    private let method: Method
    private let functionBuilderName: String
    
    public init(
        method: Method,
        functionBuilderName: String)
    {
        self.method = method
        self.functionBuilderName = functionBuilderName
    }
    
    private var returnType: String {
        return "MixboxMocksRuntime.\(functionBuilderName)<\(argumentsTupleType), \(method.returnTypeName.name)>"
    }
    
    public func render() throws -> String {
        """
        func \(method.callName)\(genericParametersClause)\(methodArguments)-> \(returnType)\(whereClause){
            let argumentsMatcher = MixboxMocksRuntime.FunctionalMatcher<\(argumentsTupleType)>(
                matchingFunction: \(matchingFunction.indent(level: 2))
            )
        
            return \(returnType)(
                functionIdentifier:
                \"\"\"
                \(method.name)
                \"\"\",
                mockManager: mockManager,
                argumentsMatcher: argumentsMatcher,
                fileLine: fileLine
            )
        }
        """
    }
    
    private func genericArgumentType(index: Int) -> String {
        return "Argument\(index)"
    }
    
    private func genericArgumentName(index: Int) -> String {
        return "argument\(index)"
    }

    // <Argument1: MixboxMocksRuntime.Matcher, Argument2: MixboxMocksRuntime.Matcher>
    private var genericParametersClause: String {
        method.parameters.render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "<\($0)>" },
            transform: { index, _ in
                "\(genericArgumentType(index: index)): MixboxMocksRuntime.Matcher"
            }
        )
    }

    // (_ argument1: Argument1, someLabel argument2: Argument2)
    private var methodArguments: String {
        method.parameters.render(
            separator: ",\n",
            valueIfEmpty: "() ",
            surround: { "(\n\($0))\n    " },
            transform: { index, parameter in
                let labeledArgument = CodeGenerationUtils.labeledArgument(
                    label: parameter.argumentLabel,
                    name: genericArgumentName(index: index)
                )
                
                let type = genericArgumentType(index: index)
                
                return "    \(labeledArgument): \(type)"
            }
        )
    }

    // where
    // Argument1.MatchingType == Int,
    // Argument2.MatchingType == Int
    private var whereClause: String {
        method.parameters.render(
            separator: ",\n",
            valueIfEmpty: " ",
            surround: {
                """
                
                    where
                    \($0.indent())
                
                """
            },
            transform: { index, parameter in
                let matchingType = parameter.typeName.validTypeName
                let genericType = genericArgumentType(index: index)
                
                return "\(genericType).MatchingType == \(matchingType)"
            }
        )
    }

    // (Int, Int)
    private var argumentsTupleType: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { _, parameter in
                parameter.typeName.validTypeName
            }
        )
    }
    
    // { (otherArgument1: Int, otherArgument2: Int) -> Bool in
    //    return argument1.valueIsMatching(otherArgument1) && argument2.valueIsMatching(otherArgument2)
    // }
    private var matchingFunction: String {
        method.parameters.isEmpty
            ? "{ true }"
            :
            """
            { \(matchingFunctionArguments) -> Bool in
                \(matchingFunctionPredicate.indent())
            }
            """
    }
    
    private func matchingFunctionArgumentName(index: Int) -> String {
        return "otherArgument\(index)"
    }
    
    // (b1: Int, b2: Int)
    private var matchingFunctionArguments: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, parameter in
                let name = matchingFunctionArgumentName(index: index)
                let type = parameter.typeName.validTypeName
                
                return "\(name): \(type)"
            }
        )
    }
    
    private var matchingFunctionPredicate: String {
        method.parameters
            .filter { parameter in
                !parameter.isClosure
            }
            .render(
                separator: " && ",
                valueIfEmpty: "true",
                transform: { index, _ in
                    let lhs = genericArgumentName(index: index)
                    let rhs = matchingFunctionArgumentName(index: index)
                    
                    return "\(lhs).valueIsMatching(\(rhs))"
                }
            )
    }
}
