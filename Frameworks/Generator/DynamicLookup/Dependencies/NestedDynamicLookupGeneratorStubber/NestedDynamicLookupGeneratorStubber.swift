// TODO: Try to remove constraint to GeneratableByFields
public final class NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType: GeneratableByFields> {
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    private let keyPath: KeyPath<GeneratedType, FieldType>
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        generatorByKeyPath: GeneratorByKeyPath<GeneratedType>,
        keyPath: KeyPath<GeneratedType, FieldType>)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.generatorByKeyPath = generatorByKeyPath
        self.keyPath = keyPath
    }
    
    public func stub(
        configure: @escaping (DynamicLookupGenerator<FieldType>) throws -> ())
        throws
    {
        let generator: DynamicLookupGenerator<FieldType> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator()
        
        try configure(generator)
        
        generatorByKeyPath[keyPath] = generator
    }
}
