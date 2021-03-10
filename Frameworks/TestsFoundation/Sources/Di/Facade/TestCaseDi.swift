import MixboxBuiltinDi
import MixboxDi
import MixboxFoundation

// Utility designed to be used in declaration of base TestCase class.
//
// Example:
//
// class MyProjectTestCase: XCTestCase {
//     let di = TestCaseDi.make(
//         dependencyCollectionRegisterer: MyProjectDependencies(),
//         dependencyInjectionFactory: BuiltInDependencyInjectionFactory()
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
    // Creates DI container, registers dependencies, registers `DependencyInjectionFactory` in container.
    public static func make(
        dependencyCollectionRegisterer: DependencyCollectionRegisterer,
        dependencyInjectionFactory: DependencyInjectionFactory)
        -> TestFailingDependencyResolver
    {
        let dependencyInjection = dependencyInjectionFactory.dependencyInjection()
        
        dependencyInjection.register(type: DependencyInjectionFactory.self) { _ in
            dependencyInjectionFactory
        }
        
        return make(
            dependencyCollectionRegisterer: dependencyCollectionRegisterer,
            dependencyInjection: dependencyInjection
        )
    }
    
    // Creates DI container, registers dependencies, registers `DependencyInjectionFactory` in container.
    // All set up with performance logging.
    public static func make(
        dependencyCollectionRegisterer: DependencyCollectionRegisterer,
        dependencyInjectionFactory: DependencyInjectionFactory,
        performanceLogger: PerformanceLogger)
        -> TestFailingDependencyResolver
    {
        let dependencyInjection = dependencyInjectionFactory.dependencyInjection()
        
        dependencyInjection.register(type: DependencyInjectionFactory.self) { _ in
            dependencyInjectionFactory
        }
        dependencyInjection.register(type: PerformanceLogger.self) { _ in
            performanceLogger
        }
        
        return make(
            dependencyCollectionRegisterer: dependencyCollectionRegisterer,
            dependencyInjection: DelegatingDependencyInjection(
                dependencyResolver: PerformanceLoggingDependencyResolver(
                    dependencyResolver: dependencyInjection,
                    performanceLogger: performanceLogger
                ),
                dependencyRegisterer: dependencyInjection
            )
        )
    }
    
    // Low-level function, no default dependencies.
    public static func make(
        dependencyCollectionRegisterer: DependencyCollectionRegisterer,
        dependencyInjection: DependencyInjection)
        -> TestFailingDependencyResolver
    {
        dependencyCollectionRegisterer.register(dependencyRegisterer: dependencyInjection)
        
        return MixboxDiTestFailingDependencyResolver(
            dependencyResolver: dependencyInjection
        )
    }
}

// Used to inject same `dependencyInjectionFactory` to DI that was passed to `make` function.
private class InjectingDependencyInjectionFactoryDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    private let dependencyInjectionFactory: DependencyInjectionFactory
    
    init(dependencyInjectionFactory: DependencyInjectionFactory) {
        self.dependencyInjectionFactory = dependencyInjectionFactory
    }
    
    func register(dependencyRegisterer: DependencyRegisterer) {
        
    }
}
