#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class CompoundDependencyResolver: DependencyResolver {
    private let resolvers: [DependencyResolver]
    
    public init(resolvers: [DependencyResolver]) {
        self.resolvers = resolvers
    }
    
    public func resolve<T>(nestedDependencyResolver: DependencyResolver) throws -> T {
        var errors = [Error]()
        for resolver in resolvers {
            do {
                // For all nested resolvings use `self` as a resolver.
                //
                // Example:
                //
                // 1. "Resolver #1" can resolve `A` with field `b: B`.
                // 2. "Resolver #2" can resolve `B`
                //
                // If we resolve A via `CompoundDependencyResolver` it will resolve A using "Resolver #1"
                // and "Resolver #1" should resolve `B` somehow. `B` is registered inside "Resolver #2",
                // not inside "Resolver #1". Factory of dependency `A` should refer to compond resolver.
                //
                // Here `nestedDependencyResolver` is used and by default it is `self` (weakly referenced),
                // but it also can be higher-level `CompoundDependencyResolver`.
                //
                // See: `CompoundDependencyResolverTests`.
                return try resolver.resolve(
                    nestedDependencyResolver: nestedDependencyResolver
                )
            } catch {
                errors.append(error)
            }
        }
        
        let errorsJoined = errors.map { String(describing: $0) }.joined(separator: ", ")
        
        throw DiError("Failed to resolve \(T.self): \(errorsJoined)")
    }
}

#endif
