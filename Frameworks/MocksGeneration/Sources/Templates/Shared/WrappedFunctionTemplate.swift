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
        return "A\(index)"
    }
    
    private func genericArgumentName(index: Int) -> String {
        return "a\(index)"
    }

    // <A1: MixboxMocksRuntime.Matcher, A2: MixboxMocksRuntime.Matcher>
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

    // (_ a1: A1, b a2: A2)
    private var methodArguments: String {
        method.parameters.render(
            separator: ", ",
            valueIfEmpty: "",
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
    // A1.MatchingType == Int,
    // A2.MatchingType == Int
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
    
    // { (b1: Int, b2: Int) -> Bool in
    //    return a1.valueIsMatching(b1) && a2.valueIsMatching(b2)
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
        return "b\(index)"
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
                let a = genericArgumentName(index: index)
                let b = matchingFunctionArgumentName(index: index)
                
                return "\(a).valueIsMatching(\(b))"
            }
        )
    }
}
