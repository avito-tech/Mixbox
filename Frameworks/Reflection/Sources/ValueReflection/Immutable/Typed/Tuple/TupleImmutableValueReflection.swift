public final class TupleImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let elements: [TupleImmutableValueReflectionElement]
    
    public init(
        type: Any.Type,
        elements: [TupleImmutableValueReflectionElement])
    {
        self.type = type
        self.elements = elements
    }
    
    public static func reflect(reflector: Reflector) -> TupleImmutableValueReflection {
        return TupleImmutableValueReflection(
            type: reflector.mirror.subjectType,
            elements: reflector.mirror.children.map { child in
                TupleImmutableValueReflectionElement(
                    label: child.label.flatMap { label in
                        // If there is no label, label is like ".0" (for first element, for example).
                        label.starts(with: ".") ? nil : label
                    },
                    value: reflector.nestedValueReflection(
                        value: child.value
                    )
                )
            }
        )
    }
}
