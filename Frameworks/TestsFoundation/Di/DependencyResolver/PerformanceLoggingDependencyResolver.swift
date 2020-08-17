import MixboxFoundation
import MixboxDi

public final class PerformanceLoggingDependencyResolver: DependencyResolver {
    private let dependencyResolver: DependencyResolver
    private let performanceLogger: PerformanceLogger
    
    public init(
        dependencyResolver: DependencyResolver,
        performanceLogger: PerformanceLogger)
    {
        self.dependencyResolver = dependencyResolver
        self.performanceLogger = performanceLogger
    }
    
    public func resolve<T>(nestedDependencyResolver: DependencyResolver) throws -> T {
        try performanceLogger.log(
            staticName: "di.resolve()",
            dynamicName: { "di_\(T.self)" },
            body: {
                try dependencyResolver.resolve(nestedDependencyResolver: nestedDependencyResolver)
            }
        )
    }
}
