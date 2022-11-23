#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

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
