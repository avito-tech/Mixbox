import MixboxDi

// This class is used to store every dependency of `DynamicLookupGenerator`
// to keep source code compatible even if dependencies will be changed.
//
public final class DynamicLookupGeneratorDependencies {
    public let dependencyResolver: DependencyResolver
    public let anyGenerator: AnyGenerator
    
    public init(
        dependencyResolver: DependencyResolver,
        anyGenerator: AnyGenerator)
    {
        self.dependencyResolver = dependencyResolver
        self.anyGenerator = anyGenerator
    }
    
    public convenience init(
        dependencyResolver: DependencyResolver)
        throws
    {
        self.init(
            dependencyResolver: dependencyResolver,
            anyGenerator: try dependencyResolver.resolve()
        )
    }
}
