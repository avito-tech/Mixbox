#if MIXBOX_ENABLE_IN_APP_SERVICES

extension DependencyRegisterer {
    // Usage:
    //
    // ```
    // di.registerMultiple { _ in RecordedAssertionFailuresHolder() }
    //     .reregister { $0 as AssertionFailureRecorder }
    //     .reregister { $0 as RecordedAssertionFailuresProvider }
    // ```
    //
    public func registerMultiple<T>(
        scope: Scope = .single,
        type: T.Type = T.self,
        factory: @escaping (DependencyResolver) throws -> T)
        -> MultipleDependenciesRegistrationContinuation<T>
    {
        register(
            scope: scope,
            type: type,
            factory: factory
        )
        
        return MultipleDependenciesRegistrationContinuation<T>(
            dependencyRegisterer: self,
            scope: scope
        )
    }
}

#endif
