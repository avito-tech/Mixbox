import SourceryRuntime

extension Method {
    public func genericParameterClause() throws -> GenericParameterClause? {
        var splitName = name.components(
            separatedBy: ">",
            excludingDelimiterBetween: Self.delimiters
        )

        guard splitName.count >= 2 else {
            return nil
        }
    
        splitName = splitName[0]
            .split(separator: "<", maxSplits: 1)
            .map({ String($0).stripped() })
        
        guard splitName.count == 2 else {
            throw ErrorString("Failed to parse GenericParameterClause")
        }
    
        let genericParameterClause = splitName[1]
    
        return GenericParameterClause(
            genericParameters: try genericParameterClause.commaSeparated().map { genericParameter in
                let components = genericParameter
                    .components(separatedBy: ":", excludingDelimiterBetween: Self.delimiters)
                    .map({ String($0).stripped() })
                
                switch components.count {
                case 1:
                    return GenericParameter(
                        name: components[0],
                        constraint: nil
                    )
                case 2:
                    return GenericParameter(
                        name: components[0],
                        constraint: components[1]
                    )
                default:
                    throw ErrorString("Failed to parse GenericParameter")
                }
            }
        )
    }
    
    private static var delimiters: (open: String, close: String) {
        ("<[({", "})]>")
    }
}
