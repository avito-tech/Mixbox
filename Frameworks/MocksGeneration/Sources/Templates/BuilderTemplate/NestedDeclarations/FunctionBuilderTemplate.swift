import SourceryRuntime

public class FunctionBuilderTemplate {
    private let method: Method
    private let genericParameterClause: GenericParameterClause?
    private let genericArgumentTypeNames: [String]
    private let functionBuilderClass: String
    
    public init(
        method: Method,
        functionBuilderClass: String)
        throws
    {
        self.method = method
        self.genericParameterClause = try method.genericParameterClause()
        self.functionBuilderClass = functionBuilderClass
        
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
        let recordedCallArgumentsMatcher = \(recordedCallArgumentsMatcherBuilder)

        return \(returnType)(
            mockManager: mockManager,
            functionIdentifier:
            \(Snippets.functionIdentifier(method: method).indent(level: 1)),
            recordedCallArgumentsMatcher: recordedCallArgumentsMatcher,
            fileLine: fileLine
        )
        """
    }
    
    private var returnType: String {
        return "MixboxMocksRuntime.\(functionBuilderClass)"
    }
    
    // <SourceT, SourceU, Argument0: MixboxMocksRuntime.Matcher, Argument1: MixboxMocksRuntime.Matcher>
    private var genericParameterClauseString: String {
        let sourceParameters = genericParameterClause.map(default: []) { genericParameterClause in
            genericParameterClause.genericParameters.map { genericParameter in
                genericParameter.name
            }
        }
        
        let matcherGenericParameters = method.parameters.enumerated().compactMap { (index, parameter) in
            parameter.isNonEscapingClosure.ifFalse {
                "\(matcherGenericArgumentTypeName(index: index)): MixboxMocksRuntime.Matcher"
            }
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
            surround: {
                """
                (
                    \($0.indent()))
                    
                """
            },
            transform: { index, parameter in
                let labeledArgument = Snippets.labeledArgumentForFunctionSignature(
                    label: parameter.argumentLabel,
                    name: Snippets.matcherArgumentName(index: index)
                )
                
                let originalType = parameter
                    .typeName
                    .validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional
                
                let argumentType = parameter.isNonEscapingClosure
                    ? "NonEscapingClosureMatcher<\(originalType)>"
                    : matcherGenericArgumentTypeName(index: index)
                
                return "\(labeledArgument): \(argumentType)"
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
        method.parameters.enumerated().filter { (_, parameter) in
            !parameter.isNonEscapingClosure
        }.render(
            separator: ",\n",
            valueIfEmpty: " ",
            surround: {
                """
                
                    where
                    \($0.indent())
                
                """
            },
            transform: { (_, pair) in
                let index = pair.offset
                let parameter = pair.element
                    
                let matchingType = parameter.typeName.validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional
                let genericType = matcherGenericArgumentTypeName(index: index)
                
                return "\(genericType).MatchingType == \(matchingType)"
            }
        )
    }

    // (Int, Int)
    private var argumentsTupleType: String {
        return Snippets.tupledArgumentsType(
            methodParameters: method.parameters
        )
    }
    
    private var recordedCallArgumentsMatcherBuilder: String {
        return method.parameters.render(
            separator: "\n",
            valueIfEmpty: "RecordedCallArgumentsMatcherBuilder().matcher()",
            surround: {
                """
                RecordedCallArgumentsMatcherBuilder()
                    \($0.indent())
                    .matcher()
                """
            },
            transform: { index, _ in
                """
                .matchNext(\(Snippets.matcherArgumentName(index: index)))
                """
            }
        )
    }
}
