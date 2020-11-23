import SourceryRuntime
import Foundation

public class ProtocolImplementationFunctionTemplate {
    private let method: SourceryRuntime.Method
    
    public init(method: SourceryRuntime.Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        """
        \(functionAttributes)func \(method.callName)\(try genericParameterClauseString())\(methodDeclarationArguments)\(functionThrowing)\(functionResult) {
            let \(mockManagerVariableName) = getMockManager()
            let \(defaultImplementationVariableName) = getDefaultImplementation(MixboxMocksRuntimeVoid.self)
            return \(body.indent())
        }
        """
    }
    
    // To avoid collision with members of protocol
    // TODO: Pass it via closure, it will resolve collisions without need of UUIDD.
    private var mockManagerVariableName: String {
        "mockManager_FE23B3FA8DA04D908BBC814A7E97FF1A"
    }
    private var defaultImplementationVariableName: String {
        "defaultImplementation_FE23B3FA8DA04D908BBC814A7E97FF1A"
    }
    
    private func genericParameterClauseString() throws -> String {
        let genericNamesWithConstraints = try method.genericParameterClause().map(default: []) { genericParameterClause in
            genericParameterClause.genericParameters.map { genericParameter in
                genericParameter.nameWithConstraint
            }
        }
        
        return genericNamesWithConstraints.render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "<\($0)>" }
        )
    }
    
    private var body: String {
        Snippets.withoutActuallyEscaping(
            parameters: method.parameters,
            argumentName: Snippets.argumentName,
            isThrowingOrRethrowing: methodThrowsOrRethrows,
            returnType: returnType,
            body: bodyWithEscapingClosures
        )
    }
    
    // TODO: Sourcery provies also keywords as attributes (`convenience`, `public`, etc). Use them.
    private var functionAttributes: String {
        method.attributes.sorted { (lhs, rhs) -> Bool in
            lhs.key < rhs.key
        }.render(
            separator: "\n",
            valueIfEmpty: "",
            surround: { "\($0)\n" },
            transform: { (_, pair: (key: String, value: Attribute)) in
                // Example: `@available(swift, introduced: 5.0)`
                
                "@\(pair.key)\(attributeArgumentsInParenthesis(attribute: pair.value))"
            }
        )
    }
    
    // Example: `(swift, introduced: 5.0)`
    private func attributeArgumentsInParenthesis(attribute: Attribute) -> String {
        attribute.arguments.sorted { (lhs, rhs) -> Bool in
            lhs.key < rhs.key
        }.render(
            separator: ", ",
            valueIfEmpty: "",
            surround: { "(\($0))" },
            transform: { (_, pair: (key: String, value: NSObject)) -> String in
                // Examples:
                // - `iOS 10.0`
                // - `swift`
                // - `*`
                // - `introduced: 5.0`
                
                // Note that fixes are more probably will break something.
                // TODO: Thoroughly test all cases.
                
                // ` ` are converted to `_` is `iOS 10.0` for some reason. Converting it back:
                let fixedKey = pair.key.replacingOccurrences(of: "_", with: " ")
                
                let notFixedValue = "\(pair.value)"
                
                // Also `*` looks like `1`
                let fixedValue = notFixedValue == "1" ? "*" : notFixedValue
                
                // For some reason key and value are separate by comma for `iOS 10.0, *`:
                return ["\(fixedKey)", "\(fixedValue)"].joined(separator: ", ")
            }
        )
    }
    
    private var bodyWithEscapingClosures: String {
        let tryPrefix = methodThrowsOrRethrows ? "try " : ""
        
        return """
        \(tryPrefix)\(mockManagerVariableName).\(mockManagerCallFunction)(
            functionIdentifier:
            \(Snippets.functionIdentifier(method: method).indent(level: 1)),
            defaultImplementation: \(defaultImplementationVariableName),
            defaultImplementationClosure: { (defaultImplementation, newValue) in
                \(tryPrefix)defaultImplementation.\(method.callName)\(methodCallArguments.indent(level: 2))
            },
            arguments: \(tupledArguments)
        )
        """
    }
    
    private var mockManagerCallFunction: String {
        if method.rethrows {
            return "callRethrows"
        } else if method.throws {
            return "callThrows"
        } else {
            return "call"
        }
    }
    
    private var methodDeclarationArguments: String {
        method.parameters.render(
            separator: ", ",
            surround: { "(\($0))" },
            transform: { index, parameter in
                let labeledArgument = Snippets.labeledArgumentForFunctionSignature(
                    label: parameter.argumentLabel,
                    name: Snippets.argumentName(index: index)
                )
                
                let type = parameter.typeName.name
                
                return "\(labeledArgument): \(type)"
            }
        )
    }
    
    private var methodCallArguments: String {
        method.parameters.render(
            separator: ",\n",
            valueIfEmpty: "()",
            surround: { "(\n\($0.indent(includingFirstLine: true))\n)" },
            transform: { index, parameter in
                let labelPrefix = parameter.argumentLabel.map(default: "", transform: { "\($0): " })
                let value = Snippets.argumentName(index: index)
                
                let callParenthesis = parameter.typeName.isAutoclosure ? "()" : ""
                
                return "\(labelPrefix)\(value)\(callParenthesis)"
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
    
    private var methodThrowsOrRethrows: Bool {
        return method.throws || method.rethrows
    }
    
    private var functionThrowing: String {
        if method.rethrows {
            return " rethrows"
        } else if method.throws {
            return " throws"
        } else {
            return ""
        }
    }
    
    private var functionResult: String {
        if method.returnTypeName.isVoid {
            return ""
        }
        
        return " -> \(returnType)"
    }
    
    private var returnType: String {
        return method.returnTypeName.validTypeName
    }
}
