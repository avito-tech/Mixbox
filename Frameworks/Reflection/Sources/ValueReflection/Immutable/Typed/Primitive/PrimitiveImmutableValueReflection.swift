public final class PrimitiveImmutableValueReflection:
    ImmutableValueReflection,
    ReflectableWithReflector
{
    public let type: Any.Type
    public let reflected: Any
    
    public init(
        type: Any.Type,
        reflected: Any)
    {
        self.type = type
        self.reflected = reflected
    }
    
    public static func reflect(reflector: Reflector) -> PrimitiveImmutableValueReflection {
        return PrimitiveImmutableValueReflection(
            type: Swift.type(of: reflector.value),
            reflected: reflector.value
        )
    }
}
