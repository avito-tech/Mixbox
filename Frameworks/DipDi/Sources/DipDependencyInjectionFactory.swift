import Dip
import MixboxDi

public final class DipDependencyInjectionFactory: DependencyInjectionFactory {
    public init() {
    }
    
    public func dependencyInjection() -> DependencyInjection {
        return DipDependencyInjection(dependencyContainer: DependencyContainer())
    }
}
