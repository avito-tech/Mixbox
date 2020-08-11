import Dip
import MixboxFoundation
import MixboxDi

public final class DipDependencyInjection: DependencyInjection {
    private let dependencyContainer: DependencyContainer
    
    public init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    public func resolve<T>() throws -> T {
        return try dependencyContainer.resolve()
    }
    
    public func register<T>(scope: Scope, type: T.Type, factory: @escaping (DependencyResolver) throws -> T) {
        let weakDependencyResolver = WeakDependencyResolver(dependencyResolver: self)
        
        dependencyContainer.register(
            scope.toDipScope(),
            type: type,
            factory: {
                try factory(weakDependencyResolver)
            }
        )
    }
}

extension Scope {
    fileprivate func toDipScope() -> ComponentScope {
        switch self {
        case .unique:
            return .unique
        case .single:
            return .singleton
        }
    }
}
