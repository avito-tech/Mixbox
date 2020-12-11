#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class TypeErasedAnyGeneratorImpl: TypeErasedAnyGenerator {
    private let anyGenerator: AnyGenerator
    private let specializations: [HashableType: TypeErasedAnyGeneratorSpecialization]
    
    public init(
        anyGenerator: AnyGenerator,
        specializations: [HashableType: TypeErasedAnyGeneratorSpecialization])
    {
        self.anyGenerator = anyGenerator
        self.specializations = specializations
    }
    
    // Note: doesn't take inheritance into account.
    public func generate(type: Any.Type) throws -> Any {
        guard let specialization = specializations[HashableType(type: type)] else {
            throw GeneratorError(
                """
                Specialization of generator for type \(type) is not registered.
                """
            )
        }
        
        return try specialization.generate(anyGenerator: anyGenerator)
    }
}

#endif
