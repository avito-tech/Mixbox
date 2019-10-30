import MixboxDi
import Dip
import MixboxTestsFoundation

public final class TestCaseDependenciesResolver {
    private let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
    
    public func resolve<T>() -> T {
        return UnavoidableFailure.doOrFail {
            try di.resolve()
        }
    }
    
    public init(registerer: DependencyCollectionRegisterer) {
        registerer.register(dependencyRegisterer: di)
        
        UnavoidableFailure.doOrFail {
            try di.completeContainerSetup()
        }
    }
}
