import Dip
import MixboxFoundation

public final class DipDependencyInjection: DependencyInjection {
    private let dependencyContainer: DependencyContainer
    
    public init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    public func completeContainerSetup() throws {
        try dependencyContainer.bootstrap()
    }
    
    public func resolve<T>() throws -> T {
        return try dependencyContainer.resolve()
    }
    
    public func register<T>(scope: Scope, type: T.Type, factory: @escaping (DependencyResolver) throws -> T) {
        dependencyContainer.register(
            scope.toDipScope(),
            type: type,
            factory: { [weak self] in
                guard let dependencyResolver = self else {
                    throw ErrorString("Internal error: dependencyContainer was deallocated, which is unexpected")
                }
                
                return try factory(dependencyResolver)
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
