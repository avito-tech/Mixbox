import MixboxDi
import MixboxUiTestsFoundation

// Add this DI if you want to test only one app.
public final class MixboxBlackSingleAppDependencies: DependencyCollectionRegisterer {
    public init() {
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        di.register(type: ApplicationProvider.self) { _ in
            ApplicationProviderImpl { XCUIApplication() }
        }
        di.register(type: ElementFinder.self) { di in
            UiKitHierarchyElementFinder(
                ipcClient: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                stepLogger: try di.resolve(),
                screenshotTaker: try di.resolve(),
                performanceLogger: try di.resolve(),
                dateProvider: try di.resolve()
            )
        }
        di.register(type: EventGenerator.self) { di in
            XcuiEventGenerator(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: Pasteboard.self) { di in
            IpcPasteboard(
                ipcClient: try di.resolve()
            )
        }
        di.register(type: ApplicationQuiescenceWaiter.self) { di in
            XcuiApplicationQuiescenceWaiter(
                applicationProvider: try di.resolve()
            )
        }
        di.register(type: PageObjectDependenciesFactory.self) { di in
            XcuiPageObjectDependenciesFactory(
                testFailureRecorder: try di.resolve(),
                ipcClient:  try di.resolve(),
                stepLogger: try di.resolve(),
                pollingConfiguration: .reduceWorkload,
                elementFinder: try di.resolve(),
                applicationProvider: try di.resolve(),
                eventGenerator: try di.resolve(),
                screenshotTaker: try di.resolve(),
                pasteboard: try di.resolve(),
                runLoopSpinningWaiter: try di.resolve(),
                performanceLogger: try di.resolve(),
                snapshotsDifferenceAttachmentGenerator: try di.resolve(),
                snapshotsComparatorFactory: try di.resolve(),
                applicationQuiescenceWaiter: try di.resolve(),
                elementSettingsDefaultsProvider: try di.resolve(),
                keyboardEventInjector: try di.resolve()
            )
        }
    }
}
