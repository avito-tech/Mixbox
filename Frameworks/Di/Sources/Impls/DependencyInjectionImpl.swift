import MixboxFoundation

public final class DependencyInjectionImpl: DependencyInjection {
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
        dependencyRegisterer.register(
            scope: scope,
            type: type,
            factory: { [weak self] _ in
                guard let dependencyResolver = self?.dependencyResolver else {
                    throw ErrorString("Internal error: dependencyResolver was deallocated, which is unexpected")
                }
                
                return try factory(dependencyResolver)
            }
        )
    }
}
