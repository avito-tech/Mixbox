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
        // We have few tests that check this. (for example, `UIViewTestabilityWithAccessibilityEnabledTests`)
        // Ideally it should be tested with a separate app, because this is
        // not a default behavior. Main tests should be tested with default settings.
        di.register(type: AccessibilityForTestAutomationInitializer.self) { di in
            PrivateApiAccessibilityForTestAutomationInitializer(
                runLoopSpinningWaiter: try di.resolve(),
                accessibilityInitializationStatusProvider: try di.resolve(),
                iosVersionProvider: try di.resolve()
            )
        }
    }
}
