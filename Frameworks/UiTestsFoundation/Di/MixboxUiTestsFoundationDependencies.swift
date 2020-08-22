import MixboxDi
import MixboxFoundation
import MixboxTestsFoundation
import MixboxUiKit
import MixboxIpc
import MixboxIpcCommon

public final class MixboxUiTestsFoundationDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    private func nestedRegisterers() -> [DependencyCollectionRegisterer] {
        return [
            MixboxTestsFoundationDependencies()
        ]
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        registerUtilities(di: di)
        registerSnapshotComparisonDependencies(di: di)
        registerIpcClients(di: di)
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
    
    private func registerIpcClients(di: DependencyRegisterer) {
        di.register(type: LazilyInitializedIpcClient.self) { _ in
            LazilyInitializedIpcClient()
        }
        di.register(type: IpcClient.self) { di in
            try di.resolve() as LazilyInitializedIpcClient
        }
        di.register(type: SynchronousIpcClient.self) { di in
            let synchronousIpcClientFactory = try di.resolve() as SynchronousIpcClientFactory
            
            return synchronousIpcClientFactory.synchronousIpcClient(
                ipcClient: try di.resolve()
            )
        }
        di.register(type: SynchronousIpcClientFactory.self) { di in
            RunLoopSpinningSynchronousIpcClientFactory(
                runLoopSpinningWaiter: try di.resolve(),
                timeout: 15
            )
        }
        di.register(type: KeyboardEventInjector.self) { di in
            IpcKeyboardEventInjector(ipcClient: try di.resolve())
        }
        di.register(type: SynchronousKeyboardEventInjector.self) { di in
            SynchronousKeyboardEventInjectorImpl(
                keyboardEventInjector: try di.resolve(),
                runLoopSpinningWaiter: try di.resolve()
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
        di.register(type: ElementSettingsDefaultsProvider.self) { _ in
            ElementSettingsDefaultsProviderImpl()
        }
    }
    
    private func registerPageObjectMakingHelperDependencies(di: DependencyRegisterer) {
        di.register(type: AlertDisplayer.self) { di in
            IpcAlertDisplayer(
                synchronousIpcClient: try di.resolve()
            )
        }
        di.register(type: PageObjectElementGenerationWizardRunner.self) { di in
            IpcPageObjectElementGenerationWizardRunner(
                synchronousIpcClient: try di.resolve()
            )
        }
        di.register(type: InteractionFailureDebugger.self) { _ in
            NoopInteractionFailureDebugger()
        }
    }
}
