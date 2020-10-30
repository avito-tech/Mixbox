public final class OptionalImmutableValueReflection: ImmutableValueReflection, ReflectableWithMirror {
    public let type: Any.Type
    public let value: TypedImmutableValueReflection?
    
    public init(
        type: Any.Type,
        value: TypedImmutableValueReflection?)
    {
        self.type = type
        self.value = value
    }
    
    public static func reflect(mirror: Mirror) -> OptionalImmutableValueReflection {
        return OptionalImmutableValueReflection(
            type: mirror.subjectType,
            value: mirror.children.first.map { child in
                TypedImmutableValueReflection.reflect(
                    reflected: child.value
                )
            }
        )
    }
}
