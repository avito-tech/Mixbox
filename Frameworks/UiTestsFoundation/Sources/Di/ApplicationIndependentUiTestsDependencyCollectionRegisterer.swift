import MixboxDi
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiKit
import MixboxIpc
import MixboxIpcCommon

// NOTE: Consider including `MixboxTestsFoundationDependencies` in your DI.
// Or simply use already prepared containers (with suffix `BoxDependencies`, like `SingleAppBlackBoxDependencies`.
public final class ApplicationIndependentUiTestsDependencyCollectionRegisterer: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        registerUtilities(di: di)
        registerSnapshotComparisonDependencies(di: di)
        registerIpc(di: di)
        registerInteractionDependencies(di: di)
        registerPageObjectMakingHelperDependencies(di: di)
    }
    
    private func registerUtilities(di: DependencyRegisterer) {
        di.register(type: EnvironmentProvider.self) { _ in
            ProcessInfoEnvironmentProvider(
                processInfo: ProcessInfo.processInfo
            )
        }
    }
    
    private func registerSnapshotComparisonDependencies(di: DependencyRegisterer) {
        di.register(type: SnapshotsDifferenceAttachmentGenerator.self) { di in
            SnapshotsDifferenceAttachmentGeneratorImpl(
                differenceImageGenerator: try di.resolve()
            )
        }
        di.register(type: DifferenceImageGenerator.self) { _ in
            DifferenceImageGeneratorImpl()
        }
        di.register(type: SnapshotsComparatorFactory.self) { _ in
            SnapshotsComparatorFactoryImpl()
        }
    }
    
    private func registerIpc(di: DependencyRegisterer) {
        di.register(type: SynchronousIpcClientFactory.self) { di in
            RunLoopSpinningSynchronousIpcClientFactory(
                runLoopSpinningWaiter: try di.resolve(),
                timeout: 15
            )
        }
    }
    
    private func registerInteractionDependencies(di: DependencyRegisterer) {
        di.register(type: ElementMatcherBuilder.self) { di in
            ElementMatcherBuilder(
                screenshotTaker: try di.resolve(),
                snapshotsDifferenceAttachmentGenerator: try di.resolve(),
                snapshotsComparatorFactory: try di.resolve()
            )
        }
        di.register(type: Retrier.self) { di in
            RetrierImpl(
                pollingConfiguration: try di.resolve(),
                waiter: try di.resolve()
            )
        }
        di.register(type: ScreenshotAttachmentsMaker.self) { di in
            ScreenshotAttachmentsMakerImpl(
                imageHashCalculator: DHashV0ImageHashCalculator(),
                screenshotTaker: try di.resolve()
            )
        }
        di.register(type: PollingConfiguration.self) { _ in
            PollingConfiguration.reduceWorkload
        }
        di.register(type: InteractionSettingsDefaultsProvider.self) { _ in
            InteractionSettingsDefaultsProviderImpl(preset: .universal)
        }
    }
    
    private func registerPageObjectMakingHelperDependencies(di: DependencyRegisterer) {
        di.register(type: InteractionFailureDebugger.self) { _ in
            NoopInteractionFailureDebugger()
        }
    }
}
