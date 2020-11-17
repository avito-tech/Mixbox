import SourceryRuntime

public class WrappedFunctionTemplate {
    private let method: Method
    private let returnType: String?
    private let customBody: String
    
    public init(
        method: Method,
        returnType: String?,
        customBody: String)
    {
        self.method = method
        self.returnType = returnType
        self.customBody = customBody
    }
    
    public func render() throws -> String {
        """
        func \(method.callName)\(genericParametersClause)\(methodArguments)\(returnClause)\(whereClause){
            let matcher = MixboxMocksRuntime.FunctionalMatcher<\(matcherTupleType)>(
                matchingFunction: \(matchingFunction.indent(level: 2))
            )
        
            \(customBody.indent())
        }
        """
    }
    
    private var returnClause: String {
        return returnType.map { " -> \($0)" } ?? ""
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
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, parameter in
                let label = parameter.argumentLabel ?? "_"
                
                let name = genericArgumentName(index: index)
                let type = genericArgumentType(index: index)
                
                return "\(label) \(name): \(type)"
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
                let matchingType = parameter.typeName.name
                let genericType = genericArgumentType(index: index)
                
                return "\(genericType).MatchingType == \(matchingType)"
            }
        )
    }

    // (Int, Int)
    private var matcherTupleType: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { _, parameter in
                parameter.typeName.name
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
                let type = parameter.typeName.name
                
                return "\(name): \(type)"
            }
        )
    }
    
    private var matchingFunctionPredicate: String {
        method.parameters.render(
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
