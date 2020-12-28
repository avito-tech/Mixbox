open class BaseImmutableValueReflectionWithFields: ImmutableValueReflectionWithFields {
    public let type: Any.Type
    public let fields: [ImmutableValueReflectionField]
    
    public init(
        type: Any.Type,
        fields: [ImmutableValueReflectionField])
    {
        self.type = type
        self.fields = fields
    }
    
    static func fields(reflector: Reflector) -> [ImmutableValueReflectionField] {
        return reflector.mirror.children.map { child in
            ImmutableValueReflectionField(
                label: child.label,
                value: reflector.nestedValueReflection(
                    value: child.value
                )
            )
        }
    }
}
