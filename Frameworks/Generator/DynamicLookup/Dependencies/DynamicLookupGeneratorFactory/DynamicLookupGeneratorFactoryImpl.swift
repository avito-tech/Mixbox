import MixboxDi

public final class DynamicLookupGeneratorFactoryImpl: DynamicLookupGeneratorFactory {
    private let anyGenerator: AnyGenerator
    
    public init(
        anyGenerator: AnyGenerator)
    {
        self.anyGenerator = anyGenerator
    }
    
    public func dynamicLookupGenerator<GeneratedType>(
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
        throws
        -> DynamicLookupGenerator<GeneratedType>
    {
        let generator = DynamicLookupGenerator<GeneratedType>(
            dynamicLookupGeneratorFactory: self,
            anyGenerator: anyGenerator,
            generate: generate
        )
        
        return generator
    }
}
