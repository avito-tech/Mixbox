import SourceryFramework
import SourceryRuntime

extension TypeName {
    // Returns string representing a type that is a valid Swift type.
    //
    // Sourcery doesn't provide a type name that is a Swift type.
    // E.g.: `name` can return `inout @autoclosure () -> Int`, but the type is `() -> Int`.
    // Sourcery has `unwrappedTypeName`, which removes annotations, but it also removes optionality for whatever reason.
    //
    public var validTypeName: String {
        var name = self.name
        
        name = name.removingAttributes()
        name = name.removingGenericConstraints()
        name = name.bracketsBalancing()
        name = name.trimmingPrefix("inout ").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            return "()"
        } else {
            return name
        }
    }
    
    // https://docs.swift.org/swift-book/ReferenceManual/Expressions.html#grammar_postfix-self-expression
    public var typeInstanceExpression: String {
        var typeName = validTypeName
        
        // `().self` leads to this error: `Cannot convert value of type '()' to expected argument type 'Any.Type'`
        // Note that `(()).self` is also an invalid expression and just adding more parentheses (like below) won't help.
        if typeName == "()" {
            typeName = "Void"
        }
        
        while typeName.hasSuffix("!") {
            // `(() -> ())!.self is not a valid expression
            typeName = "\(typeName.dropLast())"
        }
        
        if isReallyClosure || typeName.hasPrefix(")") || typeName.hasSuffix(")") {
            // `() -> ().self` is not a valid expression
            typeName = "(\(typeName))"
        }
        
        return """
        \(typeName).self
        """
    }
    
    public var validTypeNameReplacingImplicitlyUnrappedOptionalWithPlainOptional: String {
        let typeName = validTypeName
        
        if typeName.hasSuffix("!") {
            return typeName.trimmingSuffix("!") + "?"
        } else {
            return typeName
        }
    }
    
    // Note: Sourcery has bugs. It doesn't have use the concept called "lookahead"
    //
    // Example:
    // Sourcey thinks that `@escaping(Int?) -> ()` has attribute `@escaping(Int?)`,
    // which seems logical, because it is a valid attribute, however, the rest of the
    // code doesn't make sense: ` -> ()`. Swift understands this and fails to parse attribute as `@xxx(yyy)`
    // and parses it as `@xxx` instead, so the rest of code becomes valid: `(Int?) -> ()`.
    //
    // It's hard to implement this behavior actually, whithout coding
    // the entire grammar. SourceKit doesn't give such information either, so we just simply cover
    // this edge case with workarounds (that aren't working for general case).
    //
    public var validAttributes: [String: Attribute] {
        attributes.mapValues { name, value in
            // Effectively removes parentheses, because `name` doesn't contain them
            if AttributeName.attributesNamesWithoutParenthesisRawValues.contains(name) {
                return Attribute(name: name)
            } else {
                return value
            }
        }
    }
    
    public var isAutoclosure: Bool {
        return isReallyClosure
            && attributes[AttributeName.autoclosure.rawValue] != nil
    }
    
    // Sourcery likes to treat anything that looks like a closure like a closure.
    public var isReallyClosure: Bool {
        return isClosure
            && !isOptional
            && !isImplicitlyUnwrappedOptional
            && !isArray
            && !isDictionary
    }
    
    // Returns valid `ClosureType`, not something like `-> String`.
    // It doesn't guarantee the absense of errors, it just works better than what is in Sourcery.
    //
    // Note that it also unwraps optionals, etc. So the resulting type is not closure,
    // and may contain optional containing closure. This is just like how it works in Sourcery.
    //
    // Use `isReallyClosure` on `TypeName` to determine if type is really closure and not something that
    // looks like a closure, e.g. `(() -> ())?`.
    //
    // Almost a pure copy-pasta from Sourcery, except some patches.
    public var validClosureType: ClosureType? {
        guard isClosure && !isArray && !isDictionary else { return nil }
        guard isClosure else { return nil }
        
        // Those are the patches:
        let name = validUnwrappedTypeNameIfClosure()
        
        let closureTypeComponents = name.components(separatedBy: "->", excludingDelimiterBetween: ("(", ")"))

        let returnType = closureTypeComponents.suffix(from: 1)
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .joined(separator: " -> ")
        
        let returnTypeName = TypeName(returnType)

        var parametersString = closureTypeComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)

        let `throws` = parametersString.trimSuffix("throws")
        parametersString = parametersString.trimmingCharacters(in: .whitespacesAndNewlines)
        if parametersString.trimPrefix("(") { parametersString.trimSuffix(")") }
        parametersString = parametersString.trimmingCharacters(in: .whitespacesAndNewlines)
        let parameters = parseClosureParameters(parametersString)

        let composedName = "(\(parametersString))\(`throws` ? " throws" : "") -> \(returnType)"
        
        return ClosureType(
            name: composedName,
            parameters: parameters,
            returnTypeName: returnTypeName,
            throws: `throws`
        )
    }
    
    // Pure copypasta from Sourcery
    private func parseClosureParameters(_ parametersString: String) -> [MethodParameter] {
        guard !parametersString.isEmpty else {
            return []
        }

        let parameters = parametersString
            .commaSeparated()
            .compactMap({ parameter -> MethodParameter? in
                let components = parameter.trimmingCharacters(in: .whitespacesAndNewlines)
                    .colonSeparated()
                    .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })

                let isInout: Bool
                let name: String
                var typeName: String
                
                if components.count == 1 {
                    name = ""
                    typeName = components[0]
                } else {
                    name = components[0].trimmingPrefix("_").stripped()
                    typeName = components[1]
                }
                
                if typeName.hasPrefix("inout ") {
                    typeName = String(typeName.dropFirst(6))
                    isInout = true
                } else {
                    isInout = false
                }
                
                return MethodParameter(
                    argumentLabel: nil,
                    name: name,
                    typeName: TypeName(typeName),
                    isInout: isInout
                )
            })

        if parameters.count == 1 && parameters[0].typeName.isVoid {
            return []
        } else {
            return parameters
        }
    }
    
    private func validUnwrappedTypeNameIfClosure() -> String {
        var name = self.name
        
        // This is what sourcery lacks. Everything else is copypasted from different parts of sourcery.
        // This is what `unwrappedTypeName` from Soucery should be doing.
        // Maybe it's a good idea to fix it in Sourcery, make a pull request.
        // What it does: removes, for example, `@escaping` from `@escaping(Int?) -> ()` properly,
        // without removing also `(Int?)` like Sourcery does (resulting in `-> ()`, invalid type name).
        name = name.removingAttributes()
        
        name = name.removingGenericConstraints()
        name = name.bracketsBalancing()
        name = name.trimmingPrefix("inout ").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isOptional {
            if name.hasSuffix("?") || name.hasSuffix("!") {
                name = String(name.dropLast())
            } else if name.hasPrefix("Optional<") {
                name = name.drop(first: "Optional<".count, last: 1)
            } else {
                name = name.drop(first: "ImplicitlyUnwrappedOptional<".count, last: 1)
            }
            
            name = name.bracketsBalancing()
        }
        
        return name
    }
}

extension Dictionary {
    // Like `mapValues` from Swift, but with ability to access keys.
    fileprivate func mapValues(
        transform: (_ key: Key, _ value: Value) throws -> Value)
        rethrows
        -> Dictionary
    {
        var transformed = Dictionary()
        
        for (key, value) in self {
            transformed[key] = try transform(key, value)
        }
        
        return transformed
    }
}

extension String {
    fileprivate func removingAttributes() -> String {
        var typeName = self
        
        AttributeName.attributesNamesWithoutParenthesisRawValues.forEach {
            typeName = typeName.replacingOccurrences(
                of: "@\($0)",
                with: ""
            )
        }
        
        return typeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    fileprivate func removingGenericConstraints() -> String {
        if let genericConstraint = self.range(of: "where") {
            return String(self.prefix(upTo: genericConstraint.lowerBound))
                .trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return self
        }
    }
}
