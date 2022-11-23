#if MIXBOX_ENABLE_FRAMEWORK_DI && MIXBOX_DISABLE_FRAMEWORK_DI
#error("Di is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_DI || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_DI)
// The compilation is disabled
#else

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
