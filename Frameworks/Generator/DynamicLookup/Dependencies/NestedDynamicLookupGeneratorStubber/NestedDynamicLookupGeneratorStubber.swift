// TODO: Try to remove constraint to GeneratableByFields
public final class NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType: GeneratableByFields> {
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    private let keyPath: KeyPath<GeneratedType, FieldType>
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        generatorByKeyPath: GeneratorByKeyPath<GeneratedType>,
        keyPath: KeyPath<GeneratedType, FieldType>,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.generatorByKeyPath = generatorByKeyPath
        self.keyPath = keyPath
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
    }
    
    public func stub(
        configure: @escaping (DynamicLookupGenerator<FieldType>) throws -> ())
        throws
    {
        let generator: DynamicLookupGenerator<FieldType> = try dynamicLookupGeneratorFactory.dynamicLookupGenerator(
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        try configure(generator)
        
        generatorByKeyPath[keyPath] = generator
    }
}
