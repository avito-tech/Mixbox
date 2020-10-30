open class BaseCollectionImmutableValueReflection: ImmutableValueReflection, ReflectableWithMirror {
    public let type: Any.Type
    public let elements: [TypedImmutableValueReflection]
    
    public required init(
        type: Any.Type,
        elements: [TypedImmutableValueReflection])
    {
        self.type = type
        self.elements = elements
    }
    
    public static func reflect(mirror: Mirror) -> Self {
        return Self(
            type: mirror.subjectType,
            elements: mirror.children.map { child in
                TypedImmutableValueReflection.reflect(
                    reflected: child.value
                )
            }
        )
    }
}
