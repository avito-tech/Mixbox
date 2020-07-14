import MixboxDi
import MixboxFoundation
import MixboxTestsFoundation

public class MixboxDiTestCaseDependenciesResolver: TestCaseDependenciesResolver {
    private let dependencyResolver: DependencyResolver
    private let performanceLogger: PerformanceLogger
    
    public init(
        dependencyResolver: DependencyResolver,
        performanceLogger: PerformanceLogger)
    {
        self.dependencyResolver = dependencyResolver
        self.performanceLogger = performanceLogger
    }
    
    public func resolve<T>() -> T {
        do {
            return try performanceLogger.log(
                staticName: "di.resolve()",
                dynamicName: { "di_\(T.self)" },
                body: {
                    try dependencyResolver.resolve()
                }
            )
        } catch {
            UnavoidableFailure.fail("Failed to resolve \(T.self): \(error)")
        }
    }
}
