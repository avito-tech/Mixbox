#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class TypeErasedAnyGeneratorSpecializationImpl<T>:
    TypeErasedAnyGeneratorSpecialization
{
    public init() {
    }
    
    public func generate(anyGenerator: AnyGenerator) throws -> Any {
        return try anyGenerator.generate() as T
    }
}

#endif
