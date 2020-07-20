public protocol DynamicLookupGeneratorFactory {
    func dynamicLookupGenerator<GeneratedType>(
        generate: @escaping (Fields<GeneratedType>) throws -> GeneratedType)
        throws
        -> DynamicLookupGenerator<GeneratedType>
}

extension DynamicLookupGeneratorFactory {
    public func dynamicLookupGenerator<GeneratedType>()
        throws
        -> DynamicLookupGenerator<GeneratedType>
        where
        GeneratedType: GeneratableByFields
    {
        return try dynamicLookupGenerator(
            generate: { fields in
                GeneratedType.generate(fields: fields)
            }
        )
    }
}
