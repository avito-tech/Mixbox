// TODO: Fix lint.
// swiftlint:disable:next type_body_length
public final class ValueCodeGeneratorImpl: ValueCodeGenerator {
    private let indentation: String
    
    // We use character for `split` function. It doesn't support String as a separator.
    // In terms of performance the better solution will be to use streams, to avoid
    // unnecessary duplications/copying of strings. But it's hard and there is no
    // need for optimizations at the moment.
    private let newLineCharacter: Character
    private let newLine: String
    
    private let immutableValueReflectionProvider: ImmutableValueReflectionProvider
    
    public init(
        indentation: String = "    ",
        newLineCharacter: Character = "\n",
        immutableValueReflectionProvider: ImmutableValueReflectionProvider)
    {
        self.indentation = indentation
        self.newLineCharacter = newLineCharacter
        self.newLine = String(newLineCharacter)
        self.immutableValueReflectionProvider = immutableValueReflectionProvider
    }
    
    public func generateCode(value: Any, typeCanBeInferredFromContext: Bool) -> String {
        return code(
            reflection: immutableValueReflectionProvider.reflection(
                value: value
            ),
            typeCanBeInferredFromContext: typeCanBeInferredFromContext
        )
    }
    
    private func code(
        reflection: TypedImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        switch reflection {
        case let .`struct`(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .`class`(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .`enum`(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .tuple(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .optional(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .collection(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .dictionary(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .set(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .primitive(reflection):
            return code(reflection: reflection, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        case let .circularReference(value, _):
            return "<circular reference to \(type(of: value))>"
        }
    }

    // TODO: Use `typeCanBeInferredFromContext`?
    // TODO: Check if resulting init is valid?
    // Same for structs
    private func code(
        reflection: ClassImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        return code(
            type: reflection.type,
            fields: reflection.allFields
        )
    }
    
    private func code(
        reflection: StructImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        return code(
            type: reflection.type,
            fields: reflection.fields
        )
    }
    
    private func code(
        type: Any.Type,
        fields: [ImmutableValueReflectionField])
        -> String
    {
        let typeCode = code(type: type)
        
        if fields.isEmpty {
            return "\(typeCode)()"
        } else {
            return indent(
                prefix: "\(typeCode)(",
                body: code(fields: fields),
                postfix: ")"
            )
        }
    }
    
    private func code(
        reflection: EnumImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let typePrefix = typeCanBeInferredFromContext
            ? ""
            : code(type: reflection.type)
        
        let caseCode = "\(typePrefix).\(code(caseName: reflection.caseName))"
        
        if let associatedValue = reflection.associatedValue {
            let associatedValueCode = code(
                reflection: associatedValue,
                typeCanBeInferredFromContext: typeCanBeInferredFromContext
            )
            
            if associatedValueCode.starts(with: "(") {
                // E.g. tuple.
                
                return caseCode + associatedValueCode
            } else {
                return "\(caseCode)(\(associatedValueCode))"
            }
        } else {
            return caseCode
        }
    }
    
    private func code(
        reflection: TupleImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let body = reflection.elements
            .map { element in
                let label = element.label.map { "\($0): " } ?? ""
                let value = code(reflection: element.value, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
                return "\(label)\(value)"
            }
            .joined(separator: ", ")
        
        return "(\(body))"
    }
    
    private func code(
        reflection: OptionalImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        if let value = reflection.value {
            return code(reflection: value, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        } else {
            return "nil"
        }
    }
    
    private func code(
        reflection: CollectionImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let typeCode = String(describing: reflection.type)
        let body = code(elements: reflection.elements, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        
        if typeCanBeInferredFromContext && typeCode.starts(with: "Array<") {
            return body
        } else {
            return "\(typeCode)(\(body))"
        }
    }
    
    private func code(
        elements: [TypedImmutableValueReflection],
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        if elements.isEmpty {
            return "[]"
        } else {
            let body = elements
                .map { element in
                    code(reflection: element, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
                }
                .joined(separator: ",\(newLine)")
            
            return indent(
                prefix: "[",
                body: body,
                postfix: "]"
            )
        }
    }
    
    private func code(
        reflection: DictionaryImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        if reflection.pairs.isEmpty {
            return "[:]"
        } else {
            let body = reflection.pairs
                .map {
                    code(pair: $0, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
                }
                .joined(separator: ",\(newLine)")
            
            return indent(
                prefix: "[",
                body: body,
                postfix: "]"
            )
        }
    }
    
    private func code(
        pair: DictionaryImmutableValueReflectionPair,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let key = code(reflection: pair.key, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        let value = code(reflection: pair.value, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        
        return "\(key): \(value)"
    }
    
    private func code(
        reflection: SetImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let typeCode = String(describing: reflection.type)
        let body = code(elements: reflection.elements, typeCanBeInferredFromContext: typeCanBeInferredFromContext)
        
        if typeCanBeInferredFromContext && typeCode.starts(with: "Set<") {
            return body
        } else {
            return "\(typeCode)(\(body))"
        }
    }
    
    private func code(
        reflection: PrimitiveImmutableValueReflection,
        typeCanBeInferredFromContext: Bool)
        -> String
    {
        let typeCanBeInferredFromLiteral = (reflection.reflected is Int)
            || (reflection.reflected is Double)
            || (reflection.reflected is String)
        
        let typeCanBeInferred = typeCanBeInferredFromContext || typeCanBeInferredFromLiteral
        
        let body: String
        
        // `CustomDebugStringConvertible` can generate valid Swift literals, so
        // we try to use it at first, then string interpolation as a fallback.
        // String interpolation doesn't use `CustomDebugStringConvertible` first (like we want).
        // Source: https://github.com/apple/swift/blob/33452e10745575f8e1fe2d37680cb69c4940edc0/stdlib/public/core/OutputStream.swift#L376
        // Ideally we maybe want to use some solution that lldb uses, or make custom handling for every type (e.g. via switch),
        // which will be less fast and will require a lot of code. We have tests, so we know at any momen of time
        // if `CustomDebugStringConvertible` is suitable for all cases that are tested.
        if let customDebugStringConvertible = reflection.reflected as? CustomDebugStringConvertible {
            body = customDebugStringConvertible.debugDescription
        } else {
            body = "\(reflection.reflected)"
        }
        
        if typeCanBeInferred {
            return body
        } else {
            let typeName = code(type: reflection.type)
            return "\(typeName)(\(body))"
        }
    }
    
    private func code(caseName: String?) -> String {
        return caseName ?? "<NO CASE NAME>"
    }
    
    private func code(type: Any.Type) -> String {
        return "\(type)"
    }
    
    private func code(fields: [ImmutableValueReflectionField]) -> String {
        fields.map(code).joined(separator: ",\(newLine)")
    }
    
    private func code(field: ImmutableValueReflectionField) -> String {
        let label = code(label: field.label)
        let value = code(reflection: field.value, typeCanBeInferredFromContext: true)
        return "\(label): \(value)"
    }
    
    private func code(label: String?) -> String {
        return label ?? "<NO LABEL>"
    }
    
    private func indent(
        prefix: String,
        body: String,
        postfix: String)
        -> String
    {
        return prefix + newLine
            + indent(body: body) + newLine
            + postfix
    }
    
    private func indent(
        body: String)
        -> String
    {
        return body
            .split(separator: newLineCharacter)
            .map { indentation + $0 }
            .joined(separator: newLine)
    }
}
