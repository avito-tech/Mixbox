public final class OptionalImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let value: TypedImmutableValueReflection?
    
    public init(
        type: Any.Type,
        value: TypedImmutableValueReflection?)
    {
        self.type = type
        self.value = value
    }
    
    public static func reflect(reflector: Reflector) -> OptionalImmutableValueReflection {
        return OptionalImmutableValueReflection(
            type: reflector.mirror.subjectType,
            value: reflector.mirror.children.first.map { child in
                reflector.nestedValueReflection(value: child.value)
            }
        )
    }
}
