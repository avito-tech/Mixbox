import MixboxDi
import MixboxTestsFoundation

public class MixboxDiTestCaseDependenciesResolver: TestCaseDependenciesResolver {
    private let dependencyResolver: DependencyResolver
    
    public init(dependencyResolver: DependencyResolver) {
        self.dependencyResolver = dependencyResolver
    }
    
    public func resolve<T>() -> T {
        do {
            return try dependencyResolver.resolve()
        } catch {
            UnavoidableFailure.fail("Failed to resolve \(T.self): \(error)")
        }
    }
}
