import MixboxDi

// Same thing as `InitializableWithFields`, but with static func instead of `init`.
//
// See: `InitializableWithFields`
//
public protocol GeneratableByFields: DefaultGeneratorProvider {
    static func generate(fields: Fields<Self>) -> Self
}

extension GeneratableByFields {
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        let anyGenerator = AnyGeneratorImpl(dependencyResolver: dependencyResolver)
        
        let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
            anyGenerator: anyGenerator
        )
        
        return DynamicLookupGenerator(
            dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
            anyGenerator: anyGenerator,
            generate: { fields in
                self.generate(fields: fields)
            }
        )
    }
}
