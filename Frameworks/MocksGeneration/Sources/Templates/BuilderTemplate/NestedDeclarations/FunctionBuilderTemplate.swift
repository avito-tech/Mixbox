import SourceryRuntime

public class FunctionBuilderTemplate {
    private let method: Method
    private let builderType: String
    private let genericParameterClause: GenericParameterClause?
    private let genericArgumentTypeNames: [String]
    
    public init(
        method: Method,
        builderType: String)
        throws
    {
        self.method = method
        self.builderType = builderType
        self.genericParameterClause = try method.genericParameterClause()
        
        // Example: we have function `func x<T, U, Argument0>(x: (T?...) -> ([U]) -> (Argument0))`
        //
        // Stub function should contain all generic types from source function.
        // But we also have our own generic type names. We want to avoid collisions.
        //
        // There are two ways to do it:
        // - Patch source generic names
        // - Patch additional generic names (for matchers)
        //
        // Patching source generic names is error prone, because types can be complicated,
        // so we patch our own argument names instead.
        //
        let takenNames = Set(
            genericParameterClause.map(default: []) { genericParameterClause in
                genericParameterClause.genericParameters.map { $0.name }
            }
        )
        
        genericArgumentTypeNames = try method.parameters.enumerated().map { (index, _) in
            try NameCollisionAvoidance.typeNameAvoidingCollisons(
                desiredName: Snippets.matcherGenericArgumentTypeName(index: index),
                takenNames: takenNames
            )
        }
    }
    
    public func render() -> String {
        """
        func \(method.callName)\(genericParameterClauseString)\(methodArguments)-> \(returnType)\(whereClause){
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
    
    // <SourceT, SourceU, Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>
    private var genericParameterClauseString: String {
        let sourceParameters = genericParameterClause.map(default: []) { genericParameterClause in
            genericParameterClause.genericParameters.map { genericParameter in
                genericParameter.name
            }
        }
        
        let matcherGenericParameters = method.parameters.enumerated().map { (index, _) in
            "\(matcherGenericArgumentTypeName(index: index)): MixboxMocksRuntime.Matcher"
        }
        
        return (sourceParameters + matcherGenericParameters).render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "<\($0)>" }
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
                
                let type = matcherGenericArgumentTypeName(index: index)
                
                return "    \(labeledArgument): \(type)"
            }
        )
    }
    
    private func matcherGenericArgumentTypeName(index: Int) -> String {
        return genericArgumentTypeNames[index]
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
                let genericType = matcherGenericArgumentTypeName(index: index)
                
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
