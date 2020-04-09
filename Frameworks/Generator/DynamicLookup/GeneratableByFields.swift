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
        return DynamicLookupGenerator(
            dependencies: try DynamicLookupGeneratorDependencies(
                dependencyResolver: dependencyResolver
            )
        )
    }
}
