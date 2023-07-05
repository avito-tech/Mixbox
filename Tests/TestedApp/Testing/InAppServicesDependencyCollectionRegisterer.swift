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
        di.register(type: AccessibilityForTestAutomationInitializer.self) { di in
            let shouldUsePrivateApi = AccessibilityForTestAutomationInitializerSettings.shouldUsePrivateApi(
                iosVersion: (try di.resolve() as IosVersionProvider).iosVersion()
            )
            
            if shouldUsePrivateApi {
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
