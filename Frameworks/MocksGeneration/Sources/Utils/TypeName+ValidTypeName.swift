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
        
        name = name.removing(attributes: validAttributes)
        name = name.removingGenericConstraints()
        name = name.bracketsBalancing()
        name = name.trimmingPrefix("inout ").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if name.isEmpty {
            return "()"
        } else {
            return name
        }
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
            switch name {
            case AttributeName.escaping.rawValue:
                return Attribute(name: name)
            default:
                return value
            }
        }
    }
    
    // Sourcery likes to treat anything that looks like a closure like a closure.
    public var isReallyClosure: Bool {
        return isClosure
            && !isOptional
            && !isImplicitlyUnwrappedOptional
            && !isArray
            && !isDictionary
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
    fileprivate func removing(attributes:  [String: Attribute]) -> String {
        var typeName = self
        
        attributes.forEach {
            typeName = typeName.replacingOccurrences(
                of: $0.value.description,
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
