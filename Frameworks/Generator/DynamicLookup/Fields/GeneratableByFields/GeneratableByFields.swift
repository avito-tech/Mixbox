import MixboxDi

// Same thing as `InitializableWithFields`, but with static func instead of `init`.
//
// Can be used in cases where you don't want or you can't have `init(fields:)`
//
// This class is used in a fallback mechanism when Generator<T> is not registered in DI.
//
// See: `InitializableWithFields`
//
public protocol GeneratableByFields: TypeErasedGeneratableByFields, DefaultGeneratorProvider {
    static func byFieldsGenerator() -> ByFieldsGenerator<Self>
}

extension GeneratableByFields {
    public static func generate(fields: Fields<Self>) -> Self {
        return byFieldsGenerator().generate(fields: fields)
    }
    
    public static func defaultGenerator(dependencyResolver: DependencyResolver) throws -> Generator<Self> {
        // TODO: Is it correct to resolve it from `dependencyResolver`?
        //       Because it would become less configurable, because `byFieldsGeneratorResolver` is currently
        //       injected everywhere via `init`.
        //       Todo is to think about that.
        let byFieldsGeneratorResolver: ByFieldsGeneratorResolver = try dependencyResolver.resolve()
        
        let anyGenerator = AnyGeneratorImpl(
            dependencyResolver: dependencyResolver,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        let dynamicLookupGeneratorFactory = DynamicLookupGeneratorFactoryImpl(
            anyGenerator: anyGenerator,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver
        )
        
        return DynamicLookupGenerator(
            dynamicLookupGeneratorFactory: dynamicLookupGeneratorFactory,
            anyGenerator: anyGenerator,
            byFieldsGeneratorResolver: byFieldsGeneratorResolver,
            generate: { fields in
                self.generate(fields: fields)
            }
        )
    }
    
    public static func typeErasedByFieldsGenerator() -> Any {
        return byFieldsGenerator()
    }
}
