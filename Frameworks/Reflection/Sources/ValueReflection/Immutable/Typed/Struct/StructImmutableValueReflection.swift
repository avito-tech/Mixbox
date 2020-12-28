public final class StructImmutableValueReflection:
    BaseImmutableValueReflectionWithFields,
    ReflectableWithReflector
{
    public static func reflect(reflector: Reflector) -> StructImmutableValueReflection {
        return StructImmutableValueReflection(
            type: reflector.mirror.subjectType,
            fields: fields(reflector: reflector)
        )
    }
}
