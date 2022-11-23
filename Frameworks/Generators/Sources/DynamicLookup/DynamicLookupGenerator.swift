#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

//
// Generator for models (classes or structs) that allows to tweak generation of a specific field.
//
@dynamicMemberLookup
public class DynamicLookupGenerator<T>: Generator<T> {
    public typealias GeneratedType = T
    
    private let dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory
    private let anyGenerator: AnyGenerator
    private let byFieldsGeneratorResolver: ByFieldsGeneratorResolver
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    private let fields: DynamicLookupGeneratorFields<GeneratedType>
    
    public init(
        dynamicLookupGeneratorFactory: DynamicLookupGeneratorFactory,
        anyGenerator: AnyGenerator,
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver,
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
    {
        self.dynamicLookupGeneratorFactory = dynamicLookupGeneratorFactory
        self.anyGenerator = anyGenerator
        self.byFieldsGeneratorResolver = byFieldsGeneratorResolver
        
        let generatorByKeyPath = GeneratorByKeyPath<GeneratedType>(
            anyGenerator: anyGenerator
        )
        let fields = DynamicLookupGeneratorFields(generatorByKeyPath: generatorByKeyPath)
        
        self.generatorByKeyPath = generatorByKeyPath
        self.fields = fields
        
        super.init {
            try generate(fields)
        }
    }
    
    public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> NestedDynamicLookupGeneratorStubber<GeneratedType, FieldType>
    {
        get {
            return NestedDynamicLookupGeneratorStubber(
                dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
                generatorByKeyPath: generatorByKeyPath,
                keyPath: keyPath,
                byFieldsGeneratorResolver: byFieldsGeneratorResolver,
                fields: fields
            )
        }
    }
}

#endif
