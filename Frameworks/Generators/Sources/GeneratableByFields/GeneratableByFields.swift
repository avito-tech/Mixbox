#if MIXBOX_ENABLE_FRAMEWORK_GENERATORS && MIXBOX_DISABLE_FRAMEWORK_GENERATORS
#error("Generators is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_GENERATORS || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_GENERATORS)
// The compilation is disabled
#else

import MixboxDi

// Same thing as `InitializableWithFields`, but with static func instead of `init`.
//
// Can be used in cases where you don't want or you can't have `init(fields:)`
//
// This class is used in a fallback mechanism when Generator<T> is not registered in DI.
//
// See: `InitializableWithFields`
//
public protocol GeneratableByFields: TypeErasedGeneratableByFields, RepresentableByFields, DefaultGeneratorProvider {
    static func byFieldsGenerator() -> ByFieldsGenerator<Self>
}

extension GeneratableByFields {
    public static func generate(fields: Fields<Self>) throws -> Self {
        return try byFieldsGenerator().generate(fields: fields)
    }
    
    public static func typeErasedByFieldsGenerator() -> Any {
        return byFieldsGenerator()
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
                try self.generate(fields: fields)
            }
        )
    }
}

#endif
