public final class StructImmutableValueReflection: BaseImmutableValueReflectionWithFields {
    public static func reflect(mirror: Mirror) -> StructImmutableValueReflection {
        return StructImmutableValueReflection(
            type: mirror.subjectType,
            fields: fields(mirror: mirror)
        )
    }
}
