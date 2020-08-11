#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class DelegatingDependencyInjection: DependencyInjection {
    private let dependencyResolver: DependencyResolver
    private let dependencyRegisterer: DependencyRegisterer
    
    public init(
        dependencyResolver: DependencyResolver,
        dependencyRegisterer: DependencyRegisterer)
    {
        self.dependencyResolver = dependencyResolver
        self.dependencyRegisterer = dependencyRegisterer
    }
    
    public func resolve<T>() throws -> T {
        return try dependencyResolver.resolve()
    }
    
    public func register<T>(scope: Scope, type: T.Type, factory: @escaping (DependencyResolver) throws -> T) {
        let weakDependencyResolver = WeakDependencyResolver(dependencyResolver: dependencyResolver)
        
        dependencyRegisterer.register(
            scope: scope,
            type: type,
            factory: { _ in
                // Here `_` (above) is a `DependencyResolver` that is inside `dependencyRegisterer`.
                // The point of this class is to provide and ability to use different
                // objects separately, so in this case a separate `DependencyResolver`
                return try factory(weakDependencyResolver)
            }
        )
    }
}

#endif
