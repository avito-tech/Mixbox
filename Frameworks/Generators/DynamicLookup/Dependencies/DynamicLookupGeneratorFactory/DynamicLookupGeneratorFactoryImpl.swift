#if MIXBOX_ENABLE_IN_APP_SERVICES

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
