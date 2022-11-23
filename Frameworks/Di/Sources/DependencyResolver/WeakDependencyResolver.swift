#if MIXBOX_ENABLE_FRAMEWORK_DI && MIXBOX_DISABLE_FRAMEWORK_DI
#error("Di is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_DI)
// The compilation is disabled
#else

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
