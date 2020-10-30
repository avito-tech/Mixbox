public final class ClassImmutableValueReflection: BaseImmutableValueReflectionWithFields {
    public let superclassReflection: ClassImmutableValueReflection?
    
    public init(
        type: Any.Type,
        fields: [ImmutableValueReflectionField],
        superclassReflection: ClassImmutableValueReflection?)
    {
        self.superclassReflection = superclassReflection
        
        super.init(
            type: type,
            fields: fields
        )
    }
    
    public var allFields: [ImmutableValueReflectionField] {
        let superclassFields = superclassReflection?.allFields ?? []
        return superclassFields + fields
    }
    
    public static func reflect(mirror: Mirror) -> ClassImmutableValueReflection {
        return ClassImmutableValueReflection(
            type: mirror.subjectType,
            fields: fields(mirror: mirror),
            superclassReflection: mirror.superclassMirror.map { mirror in
                ClassImmutableValueReflection.reflect(mirror: mirror)
            }
        )
    }
}
