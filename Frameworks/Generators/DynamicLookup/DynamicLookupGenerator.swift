#if MIXBOX_ENABLE_IN_APP_SERVICES

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
    private let fields: Fields<GeneratedType>
    
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
        -> FieldType
    {
        get {
            return fields[dynamicMember: keyPath]
        }
        set {
            generatorByKeyPath[keyPath] = Generator<FieldType> { newValue }
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
                byFieldsGeneratorResolver: byFieldsGeneratorResolver
            )
        }
    }
}

#endif
