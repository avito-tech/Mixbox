public final class ImmutableValueReflectionProviderImpl:
    ImmutableValueReflectionProvider
{
    public init() {
    }
    
    // MARK: - ImmutableValueReflectionProvider
    
    public func reflection(
        value: Any)
        -> TypedImmutableValueReflection
    {
        let reflector = ReflectorImpl(
            value: value,
            mirror: Mirror(reflecting: value),
            parents: []
        )
        
        return reflector.nestedValueReflection(value: value)
    }
}
