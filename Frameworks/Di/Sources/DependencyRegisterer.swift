public protocol DependencyRegisterer {
    func register<T>(
        scope: Scope,
        type: T.Type,
        factory: @escaping (DependencyResolver) throws -> T)
}

extension DependencyRegisterer {
    // There is a good reason to make dependencies single:
    // - Stateless classes can be single.
    // - Stateless classes are better than stateful.
    // - It is good to register a factory for a statefull class instead of
    //   registering a dependency with .unique scope
    public func register<T>(
        type: T.Type,
        factory: @escaping (DependencyResolver) throws -> T)
    {
        register(
            scope: .single,
            type: type,
            factory: factory
        )
    }
}
