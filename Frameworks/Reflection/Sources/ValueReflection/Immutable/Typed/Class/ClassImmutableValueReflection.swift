public final class ClassImmutableValueReflection:
    BaseImmutableValueReflectionWithFields,
    ReflectableWithReflector
{
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
    
    public static func reflect(reflector: Reflector) -> ClassImmutableValueReflection {
        return ClassImmutableValueReflection(
            type: reflector.mirror.subjectType,
            fields: fields(reflector: reflector),
            superclassReflection: reflector.mirror.superclassMirror.flatMap { mirror in
                let reflection = reflector.nestedValueReflection(
                    value: reflector.value,
                    mirror: mirror
                )
                
                switch reflection {
                case let .class(superclassReflection):
                    return superclassReflection
                default:
                    // TODO: Assert or throw error instead?
                    return nil
                }
            }
        )
    }
}
