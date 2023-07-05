import MixboxDi
import MixboxInAppServices
import MixboxFoundation
import TestsIpc
import MixboxUiKit

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
        //
        // Note: we want to test both cases, we sacrifice iOS 14 for this purpose
        di.register(type: AccessibilityForTestAutomationInitializer.self) { di in
            if (try di.resolve() as IosVersionProvider).iosVersion().majorVersion == MixboxIosVersions.Supported.iOS14.majorVersion {
                return PrivateApiAccessibilityForTestAutomationInitializer(
                    runLoopSpinningWaiter: try di.resolve(),
                    accessibilityInitializationStatusProvider: try di.resolve(),
                    iosVersionProvider: try di.resolve()
                )
            } else {
                return NoopAccessibilityForTestAutomationInitializer()
            }
        }
    }
}
