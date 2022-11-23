#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

public protocol DynamicLookupGeneratorFactory {
    func dynamicLookupGenerator<GeneratedType>(
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
        throws
        -> DynamicLookupGenerator<GeneratedType>
}

extension DynamicLookupGeneratorFactory {
    public func dynamicLookupGenerator<GeneratedType>(
        byFieldsGeneratorResolver: ByFieldsGeneratorResolver)
        throws
        -> DynamicLookupGenerator<GeneratedType>
    {
        let byFieldsGenerator: ByFieldsGenerator<GeneratedType> = try byFieldsGeneratorResolver.resolveByFieldsGenerator()
        
        return try dynamicLookupGenerator(
            generate: { fields in
                try byFieldsGenerator.generate(fields: fields)
            }
        )
    }
}

#endif
