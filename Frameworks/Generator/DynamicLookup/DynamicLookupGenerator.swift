import MixboxDi

//
// Generator for models (classes or structs) that allows to tweak generation of a specific field.
//
@dynamicMemberLookup
public class DynamicLookupGenerator<T>: Generator<T> {
    public typealias GeneratedType = T
    
    private let generators: GeneratorByKeyPath<GeneratedType>
    private let fields: Fields<GeneratedType>
    
    public init(
        dependencies: DynamicLookupGeneratorDependencies,
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
    {
        let generators = GeneratorByKeyPath<GeneratedType>(
            anyGenerator: dependencies.anyGenerator
        )
        let fields = Fields(generators: generators)
        
        self.generators = generators
        self.fields = fields
        
        super.init {
            try generate(fields)
        }
    }
    
    public subscript<FieldType>(dynamicMember keyPath: KeyPath<GeneratedType, FieldType>) -> FieldType {
        get {
            return fields[dynamicMember: keyPath]
        }
        set {
            generators[keyPath] = Generator<FieldType> { newValue }
        }
    }
}

extension DynamicLookupGenerator where T: GeneratableByFields {
    public convenience init(
        dependencies: DynamicLookupGeneratorDependencies)
    {
        self.init(dependencies: dependencies) { fields in
            T.generate(fields: fields)
        }
    }
}
