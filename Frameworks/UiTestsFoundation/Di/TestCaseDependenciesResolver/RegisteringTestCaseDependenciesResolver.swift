import MixboxDi
import Dip
import MixboxTestsFoundation

public final class RegisteringTestCaseDependenciesResolver: MixboxDiTestCaseDependenciesResolver {
    private let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
    
    public init(registerer: DependencyCollectionRegisterer) {
        registerer.register(dependencyRegisterer: di)
        
        do {
            try di.completeContainerSetup()
        } catch {
            UnavoidableFailure.fail("Failed to completeContainerSetup: \(error)")
        }
        
        super.init(dependencyResolver: di)
    }
}
