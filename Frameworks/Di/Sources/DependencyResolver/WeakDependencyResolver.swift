#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class WeakDependencyResolver: DependencyResolver {
    private weak var dependencyResolver: DependencyResolver?
    
    public init(
        dependencyResolver: DependencyResolver)
    {
        self.dependencyResolver = dependencyResolver
    }
    
    public func resolve<T>(nestedDependencyResolver: DependencyResolver) throws -> T {
        guard let dependencyResolver = dependencyResolver else {
            throw DiError("Failed to resolve dependency: DependencyResolver has been deallocated.")
        }
        
        return try dependencyResolver.resolve(nestedDependencyResolver: nestedDependencyResolver)
    }
}

#endif
