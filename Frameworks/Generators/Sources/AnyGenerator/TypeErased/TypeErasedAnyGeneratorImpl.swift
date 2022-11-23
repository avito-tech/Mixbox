#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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
