import SourceryRuntime
import Foundation

// TODO: Split?
// swiftlint:disable file_length type_body_length
public class ProtocolImplementationFunctionTemplate {
    private let method: SourceryRuntime.Method
    
    public init(method: SourceryRuntime.Method) {
        self.method = method
    }
    
    public func render() throws -> String {
        """
        \(functionAttributes)func \(method.callName)\(try genericParameterClauseString())\(methodDeclarationArguments)\(functionThrowing)\(functionResult) {
            let \(mockManagerVariableName) = getMockManager(MixboxMocksRuntimeVoid.self)
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
            \(Snippets.functionIdentifier(method: method).indent()),
            defaultImplementation: \(defaultImplementationVariableName.indent()),
            defaultImplementationClosure: { (defaultImplementation, tupledArguments) in
                \(tryPrefix)defaultImplementation.\(method.callName)\(methodCallArguments.indent(level: 2))
            },
            tupledArguments: \(tupledArguments.indent()),
            nonEscapingCallArguments: \(nonEscapingCallArguments.indent()),
            generatorSpecializations: \(knownTypeGenerationSpecialzations().indent())
        )
        """
    }
    
    private func knownTypeGenerationSpecialzations() -> String {
        allTypeInstanceExpressions().render(
            separator: "\n",
            surround: {
                """
                TypeErasedAnyGeneratorSpecializationsBuilder()
                    \($0.indent())
                    .specializations
                """
            },
            transform: { _, expression in
                ".add(\(expression))"
            }
        )
    }
    
    private func allTypeInstanceExpressions() -> Set<String> {
        return Set(
            [method.returnTypeName.typeInstanceExpression] + method.parameters.flatMap {
                [$0.typeName.typeInstanceExpression] + $0.typeName.validClosureType.map(default: []) {
                    $0.parameters.map { $0.typeName.typeInstanceExpression }
                }
            }
        )
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
                let callParenthesis = parameter.typeName.isAutoclosure ? "()" : ""
                
                let tupleMemberSelector = method.parameters.count > 1
                    ? ".\(index)" // x: (Int, Int) => x.0, x.1
                    : ""          // x: (Int) => x
                
                return "\(labelPrefix)tupledArguments\(tupleMemberSelector)\(callParenthesis)"
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
    
    private var nonEscapingCallArguments: String {
        return method.parameters.render(
            separator: ",\n",
            surround: {
                """
                MixboxMocksRuntime.NonEscapingCallArguments(arguments: [
                    \($0.indent())
                ])
                """
            },
            transform: { index, parameter in
                """
                MixboxMocksRuntime.NonEscapingCallArgument(
                    name: \(Snippets.stringLiteral(parameter.name.convertEmptyToNil()).indent()),
                    label: \(Snippets.stringLiteral(parameter.argumentLabel.convertEmptyToNil()).indent()),
                    type: \(parameter.typeName.typeInstanceExpression.indent()),
                    value: \(nonEscapingCallArgumentValue(index: index, parameter: parameter).indent())
                )
                """
            }
        )
    }
    
    private func nonEscapingCallArgumentValue(
        index: Int,
        parameter: MethodParameter)
        -> String
    {
        // There is no way to detect that something is a closure in Swift 5.3
        // using a private API. This is a simple way to do it in runtime using private API:
        //
        // ```
        // @_silgen_name("swift_OpaqueSummary")
        // internal func _opaqueSummary(_ metadata: Any.Type) -> UnsafePointer<CChar>?
        //
        // func isClosure(_ any: Any) -> Bool {
        //     let mirror = Mirror(reflecting: any)
        //
        //     if let cString = _opaqueSummary(mirror.subjectType),
        //        let opaqueSummary = String(validatingUTF8: cString)
        //     {
        //         // This is guaranteed to be an indicator that object is function and
        //         // that object is not something else, see `swift_OpaqueSummary`:
        //         return opaqueSummary == "(Function)"
        //     } else {
        //         return false
        //     }
        // }
        // ```
        //
        // (more complex way is to hack deep into C++ code and call `getKind()` on `Metadata` and
        // handle `MetadataKind::Function` case, see `ReflectionMirror.mm` in `swift` repo)
        //
        // This code relies on private API. The reasons not to use it:
        // - Private API can change. However it's highly unlikely that it would be impossible
        //   that in future Swift will lack the ablity to determine if object is a function.
        // - There will be still other challanging things like ability to dynamically call a closure.
        //
        // All those things will complicate the code, make it dependent on private API, so
        // the code generation is used to add ability to inspect values at runtime. Note
        // that code generation can be much less reliable than doing same thing in runtime,
        // because code generation is much less supported by Apple, and a lot of things
        // are done by community and the quality of those things is not good (like using regexps instead of AST).
        //
        if let closure = parameter.typeName.validClosureType {
            if parameter.isNonEscapingClosure {
                return closureNonEscapingCallArgumentValue(
                    argumenIndex: index,
                    closure: closure,
                    isOptional: false,
                    parameter: parameter,
                    caseName: "nonEscapingClosure",
                    className: "NonEscapingClosureArgumentValue"
                )
            } else if parameter.isEscapingClosure {
                return closureNonEscapingCallArgumentValue(
                    argumenIndex: index,
                    closure: closure,
                    isOptional: false,
                    parameter: parameter,
                    caseName: "escapingClosure",
                    className: "EscapingClosureArgumentValue"
                )
            } else if parameter.isOptional {
                return closureNonEscapingCallArgumentValue(
                    argumenIndex: index,
                    closure: closure,
                    isOptional: true,
                    parameter: parameter,
                    caseName: "optionalEscapingClosure",
                    className: "OptionalEscapingClosureArgumentValue"
                )
            } else {
                return regularNonEscapingCallArgumentValue(argumenIndex: index)
            }
        } else {
            return regularNonEscapingCallArgumentValue(argumenIndex: index)
        }
    }
    
    private func regularNonEscapingCallArgumentValue(argumenIndex: Int) -> String {
        """
        MixboxMocksRuntime.NonEscapingCallArgumentValue.regular(
            MixboxMocksRuntime.RegularArgumentValue(
                value: \(Snippets.argumentName(index: argumenIndex)) as Any
            )
        )
        """
    }
    
    // TODO: Split.
    // swiftlint:disable:next function_body_length
    private func closureNonEscapingCallArgumentValue(
        argumenIndex: Int,
        closure: ClosureType,
        isOptional: Bool,
        parameter: MethodParameter,
        caseName: String,
        className: String)
        -> String
    {
        let argumentTypes = closure.parameters.render(
            separator: ",\n",
            valueIfEmpty: "[]",
            surround: {
                """
                [
                    \($0.indent())
                ]
                """
            },
            transform: { _, parameter in
                parameter.typeName.typeInstanceExpression
            }
        )
        
        let closureArgumentName = Snippets.argumentName(index: argumenIndex)
        
        let unwrapOperatorSuffix = isOptional ? "?" : ""
        
        let closureTryPrefix = closure.throws ? "try " : ""
        
        let callImplementation = closure.parameters.render(
            separator: ",\n",
            valueIfEmpty:
                """
                { _ in
                    \(closureTryPrefix)\(closureArgumentName)\(unwrapOperatorSuffix)() as Any
                }
                """,
            surround: {
                """
                { arguments in
                    \(closureTryPrefix)\(closureArgumentName)\(unwrapOperatorSuffix)(
                        \($0.indent(level: 2))
                    ) as Any
                }
                """
            },
            transform: { index, parameter in
                let ampersandPrefix = parameter.inout ? "&" : ""
                return """
                \(ampersandPrefix)arguments[\(index)]
                """
            }
        )
        
        return """
        MixboxMocksRuntime.NonEscapingCallArgumentValue.\(caseName)(
            MixboxMocksRuntime.\(className.indent(level: 1))(
                value: \(closureArgumentName.indent(level: 2)),
                reflection: MixboxMocksRuntime.ClosureArgumentValueReflection(
                    argumentTypes: \(argumentTypes.indent(level: 3)),
                    returnValueType: \(closure.returnTypeName.typeInstanceExpression.indent(level: 3)),
                    callImplementation: \(callImplementation.indent(level: 3))
                )
            )
        )
        """
    }
    
    private var methodThrowsOrRethrows: Bool {
        return method.throws || method.rethrows
    }
    
    private func closureThrowing(closure: ClosureType) -> String {
        if closure.throws {
            return " throws"
        } else {
            return ""
        }
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
