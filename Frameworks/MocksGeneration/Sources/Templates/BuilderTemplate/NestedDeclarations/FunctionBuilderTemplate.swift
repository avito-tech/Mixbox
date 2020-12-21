import SourceryRuntime

public class FunctionBuilderTemplate {
    private let method: Method
    private let functionBuilderClass: String
    private let genericParameterClause: GenericParameterClause?
    
    public init(
        method: Method,
        functionBuilderClass: String)
        throws
    {
        self.method = method
        self.functionBuilderClass = functionBuilderClass
        self.genericParameterClause = try method.genericParameterClause()
    }
    
    public func render() -> String {
        """
        func \(method.callName)\(genericParameterClauseString)\(methodArguments)-> \(returnType){
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
        
        return sourceParameters.render(
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
                
                let argumentType: String
                
                if parameter.isNonEscapingClosure {
                    argumentType = "NonEscapingClosureMatcher<\(originalType)>"
                } else {
                    argumentType = matcherArgumentTypeName(parameter: parameter)
                }
                
                return "\(labeledArgument): \(argumentType)"
            }
        )
    }
    
    private func matcherArgumentTypeName(parameter: MethodParameter) -> String {
        return "Matcher<\(parameter.typeName.validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional)>"
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
