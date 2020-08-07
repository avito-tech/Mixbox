#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class MultipleDependenciesRegistrationContinuation<T> {
    private let dependencyRegisterer: DependencyRegisterer
    
    public init(dependencyRegisterer: DependencyRegisterer) {
        self.dependencyRegisterer = dependencyRegisterer
    }
    
    @discardableResult
    public func reregister<U>(
        scope: Scope = .single,
        type: U.Type = U.self,
        transform: @escaping (T) -> U)
        -> MultipleDependenciesRegistrationContinuation<T>
    {
        dependencyRegisterer.register(
            scope: scope,
            type: type,
            factory: { di in
                transform(try di.resolve() as T)
            }
        )
        
        return MultipleDependenciesRegistrationContinuation<T>(
            dependencyRegisterer: dependencyRegisterer
        )
    }
}

#endif
