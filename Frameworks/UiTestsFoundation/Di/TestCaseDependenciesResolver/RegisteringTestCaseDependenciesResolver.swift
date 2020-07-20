import MixboxDi
import Dip
import MixboxFoundation
import MixboxTestsFoundation

// Utility designed to be used in declaration of base TestCase class.
//
// Example:
//
// class MyProjectTestCase: XCTestCase {
//     let di = TestCaseDi.make(
//         dependencyCollectionRegisterer: MyProjectDependencies()
//     )
// }
//
// The benefits of using this utility:
//
// 1. Very small boilerplate of adding dependencies (see the example above).
// 2. Very small boilerplate of resolving dependencies: `di.resolve() as MyDependency`
// 3. Allows you to declare dependencies in a separate class (and you can put it in a separate file)
//
public final class TestCaseDi {
    public static func make(
        dependencyCollectionRegisterer: DependencyCollectionRegisterer,
        dependencyInjection: DependencyInjection = DipDependencyInjection(dependencyContainer: DependencyContainer()))
        -> TestCaseDependenciesResolver
    {
        dependencyCollectionRegisterer.register(dependencyRegisterer: dependencyInjection)
        
        return MixboxDiTestCaseDependenciesResolver(
            dependencyResolver: dependencyInjection
        )
    }
    
    public static func make(
        dependencyCollectionRegisterer: DependencyCollectionRegisterer,
        dependencyInjection: DependencyInjection = DipDependencyInjection(dependencyContainer: DependencyContainer()),
        performanceLogger: PerformanceLogger)
        -> TestCaseDependenciesResolver
    {
        return make(
            dependencyCollectionRegisterer: dependencyCollectionRegisterer,
            dependencyInjection: DependencyInjectionImpl(
                dependencyResolver: PerformanceLoggingTestCaseDependenciesResolver(
                    dependencyResolver: dependencyInjection,
                    performanceLogger: performanceLogger
                ),
                dependencyRegisterer: dependencyInjection
            )
        )
    }
}
