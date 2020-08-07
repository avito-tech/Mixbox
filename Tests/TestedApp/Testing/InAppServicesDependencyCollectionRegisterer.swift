import MixboxDi
import MixboxInAppServices
import MixboxFoundation
import TestsIpc

final class InAppServicesDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            InAppServicesDefaultDependencyCollectionRegisterer()
        ]
    }
    
    func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        di.register(type: PerformanceLogger.self) { _ in
            Singletons.performanceLogger
        }
    }
}
