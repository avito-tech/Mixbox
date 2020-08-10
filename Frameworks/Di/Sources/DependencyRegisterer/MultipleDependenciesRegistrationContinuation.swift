#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class MultipleDependenciesRegistrationContinuation<T> {
    private let dependencyRegisterer: DependencyRegisterer
    private let scope: Scope
    
    public init(dependencyRegisterer: DependencyRegisterer, scope: Scope) {
        self.dependencyRegisterer = dependencyRegisterer
        self.scope = scope
    }
    
    // NOTE: Reregistering can be tricky.
    //
    // You may want to register your stateless classes as `.single`, but you
    // also may want to reregister them as `.unique`. This is because you
    // probably want to just reference registered type, not registered instance,
    // which will occur because `.single` dependencies are cached.
    //
    // For example:
    //
    // ```
    // di.registerMultiple(scope: .single, type: Employee.self) { _ in Alice() }
    //     .reregister(scope: .unique) { $0 as Colleague }
    // ```
    //
    // If you want to replace `Alice` with `Bob` for whatever reasons, you may also want to
    // resolve `Bob` as `Collegue` instead of `Alice`. But if you reregister her as `.single`,
    // then she will be cached forever and `Bob` will never be resolved as `Collegue`.
    //
    // This will only happen if `Alice` was resolved once. Otherwise `Bob` will just be resolved
    // in any case.
    //
    // And keep in mind that resolving a `.single` dependency will store it somewhere, which can
    // be unexpected for you if you override dependency later after resolve. You may think
    // that it will be changed everywhere where it was resolved, but it will not.
    //
    @discardableResult
    public func reregister<U>(
        scope: Scope,
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
            dependencyRegisterer: dependencyRegisterer,
            scope: scope
        )
    }
    
    // Reregisters with same scope that was in a root object.
    @discardableResult
    public func reregister<U>(
        type: U.Type = U.self,
        transform: @escaping (T) -> U)
        -> MultipleDependenciesRegistrationContinuation<T>
    {
        return reregister(
            scope: scope,
            type: type,
            transform: transform
        )
    }
}

#endif
