#if MIXBOX_ENABLE_IN_APP_SERVICES

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
                byFieldsGenerator.generate(fields: fields)
            }
        )
    }
}

#endif
