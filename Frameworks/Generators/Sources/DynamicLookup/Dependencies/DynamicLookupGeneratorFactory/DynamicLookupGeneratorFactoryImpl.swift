#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public final class DynamicLookupGeneratorFactoryImpl: DynamicLookupGeneratorFactory {
    private let anyGenerator: AnyGenerator
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    
    public init(
        anyGenerator: AnyGenerator,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
    {
        self.anyGenerator = anyGenerator
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
    }
    
    public func dynamicLookupGenerator<GeneratedType>(
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
        throws
        -> DynamicLookupGenerator<GeneratedType>
    {
        let generator = DynamicLookupGenerator<GeneratedType>(
            dynamicLookupGeneratorFactory: self,
            anyGenerator: anyGenerator,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            generate: generate
        )
        
        return generator
    }
}

#endif
