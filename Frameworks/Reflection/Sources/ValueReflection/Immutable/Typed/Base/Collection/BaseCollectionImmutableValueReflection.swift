open class BaseCollectionImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let elements: [TypedImmutableValueReflection]
    
    public required init(
        type: Any.Type,
        elements: [TypedImmutableValueReflection])
    {
        self.type = type
        self.elements = elements
    }
    
    public static func reflect(reflector: Reflector) -> Self {
        return Self(
            type: reflector.mirror.subjectType,
            elements: reflector.mirror.children.map { child in
                reflector.nestedValueReflection(value: child.value)
            }
        )
    }
}
