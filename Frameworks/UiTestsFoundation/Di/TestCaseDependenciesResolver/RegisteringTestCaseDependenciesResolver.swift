import MixboxDi
import Dip
import MixboxFoundation
import MixboxTestsFoundation

public final class RegisteringTestCaseDependenciesResolver: MixboxDiTestCaseDependenciesResolver {
    private let di = DipDependencyInjection(dependencyContainer: DependencyContainer())
    
    public init(registerer: DependencyCollectionRegisterer, performanceLogger: PerformanceLogger) {
        registerer.register(dependencyRegisterer: di)
        
        do {
            try di.completeContainerSetup()
        } catch {
            UnavoidableFailure.fail("Failed to completeContainerSetup: \(error)")
        }
        
        super.init(dependencyResolver: di, performanceLogger: performanceLogger)
    }
}
