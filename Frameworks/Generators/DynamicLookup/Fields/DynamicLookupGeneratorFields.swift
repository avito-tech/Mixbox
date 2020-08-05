#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class DynamicLookupGeneratorFields<T>: Fields<T> {
    private let generatorByKeyPath: GeneratorByKeyPath<GeneratedType>
    
    public init(generatorByKeyPath: GeneratorByKeyPath<GeneratedType>) {
        self.generatorByKeyPath = generatorByKeyPath
    }
    
    override public subscript<FieldType>(
        dynamicMember keyPath: KeyPath<GeneratedType, FieldType>)
        -> FailableProperty<FieldType>
    {
        let generator: Generator<FieldType> = generatorByKeyPath[keyPath]
        
        return FailableProperty { try generator.generate() }
    }
}

#endif
