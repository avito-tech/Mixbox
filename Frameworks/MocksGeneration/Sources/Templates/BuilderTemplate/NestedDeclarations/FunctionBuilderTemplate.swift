import SourceryRuntime

public class FunctionBuilderTemplate {
    private let method: Method
    private let builderType: String
    
    public init(
        method: Method,
        builderType: String)
    {
        self.method = method
        self.builderType = builderType
    }
    
    public func render() -> String {
        """
        func \(method.callName)\(genericParametersClause)\(methodArguments)-> \(returnType)\(whereClause){
            \(body.indent())
        }
        """
    }
    
    private var body: String {
        """
        let argumentsMatcher = MixboxMocksRuntime.FunctionalMatcher<\(argumentsTupleType)>(
            matchingFunction: \(matchingFunction.indent(level: 1))
        )

        return \(returnType)(
            functionIdentifier:
            \(Snippets.functionIdentifier(method: method).indent(level: 1)),
            mockManager: mockManager,
            argumentsMatcher: argumentsMatcher,
            fileLine: fileLine
        )
        """
    }
    
    private var returnType: String {
        return "MixboxMocksRuntime.\(functionBuilderName)<\(argumentsTupleType), \(method.returnTypeName.validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional)>"
    }
    
    private var functionBuilderName: String {
        "\(builderType)FunctionBuilder"
    }
    
    // <Argument1: MixboxMocksRuntime.Matcher, Argument2: MixboxMocksRuntime.Matcher>
    private var genericParametersClause: String {
        method.parameters.render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "<\($0)>" },
            transform: { index, _ in
                "\(Snippets.genericArgumentTypeName(index: index)): MixboxMocksRuntime.Matcher"
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
                let labeledArgument = Snippets.labeledArgument(
                    label: parameter.argumentLabel,
                    name: Snippets.argumentName(index: index)
                )
                
                let type = Snippets.genericArgumentTypeName(index: index)
                
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
                let matchingType = parameter.typeName.validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional
                let genericType = Snippets.genericArgumentTypeName(index: index)
                
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
                parameter.typeName.validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional
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
    
    private func matchingFunctionOtherArgumentName(index: Int) -> String {
        return "otherArgument\(index)"
    }
    
    // Note: types are omitted. This is because if type is closure,
    // then we have to deal with non-escaping closures, and there is no
    // way to reliably detect if closure is non-escaping, because it can be
    // a typealias from another module.
    private var matchingFunctionArguments: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, _ in
                let name = matchingFunctionOtherArgumentName(index: index)
                
                return "\(name)"
            }
        )
    }
    
    private var matchingFunctionPredicate: String {
        method.parameters
            .render(
                separator: "\n    && ",
                valueIfEmpty: "true",
                transform: { index, _ in
                    let lhs = Snippets.argumentName(index: index)
                    let rhs = matchingFunctionOtherArgumentName(index: index)
                    
                    return "\(lhs).valueIsMatching(\(rhs))"
                }
            )
    }
}
