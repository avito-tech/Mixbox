#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public final class NestedDynamicLookupGeneratorStubber<GeneratedType: RepresentableByFields, FieldType> {
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    private let keyPath: KeyPath<GeneratedType, FieldType>
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let fields: DynamicLookupGeneratorFields<GeneratedType>
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        generatorByKeyPath: GeneratorByKeyPath<GeneratedType>,
        keyPath: KeyPath<GeneratedType, FieldType>,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        fields: DynamicLookupGeneratorFields<GeneratedType>)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.generatorByKeyPath = generatorByKeyPath
        self.keyPath = keyPath
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        self.fields = fields
    }
    
    public func set(_ value: FieldType) {
        generatorByKeyPath[keyPath] = Generator<FieldType> { value }
    }
    
    public func get() throws -> FieldType {
        return try fields[dynamicMember: keyPath].get()
    }
    
}

extension NestedDynamicLookupGeneratorStubber where FieldType: RepresentableByFields {
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

#endif
