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
    
    // swiftlint:disable:next function_body_length
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        nestedRegisterers().forEach { $0.register(dependencyRegisterer: di) }
        
        // TODO: Move to MixboxGrayDependencies
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
        // end of TODO
        
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
        di.register(type: PollingConfiguration.self) { _ in
            PollingConfiguration.reduceWorkload
        }
        di.register(type: ElementSettingsDefaultsProvider.self) { _ in
            ElementSettingsDefaultsProviderImpl()
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
        di.register(type: EnvironmentProvider.self) { _ in
            ProcessInfoEnvironmentProvider(
                processInfo: ProcessInfo.processInfo
            )
        }
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
    }
}
