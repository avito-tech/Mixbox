import MixboxDi
import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class MixboxGrayDependencies: DependencyCollectionRegisterer {
    private let mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies
    
    public init(mixboxUiTestsFoundationDependencies: MixboxUiTestsFoundationDependencies) {
        self.mixboxUiTestsFoundationDependencies = mixboxUiTestsFoundationDependencies
    }
    
    public func register(dependencyRegisterer di: DependencyRegisterer) {
        mixboxUiTestsFoundationDependencies.register(dependencyRegisterer: di)
        
        di.register(type: ApplicationFrameProvider.self) { _ in
            GrayApplicationFrameProvider()
        }
        di.register(type: WindowsProvider.self) { di in
            WindowsProviderImpl(
                application: UIApplication.shared,
                iosVersionProvider: try di.resolve()
            )
        }
        di.register(type: ScreenshotTaker.self) { di in
            GrayScreenshotTaker(
                windowsProvider: try di.resolve(),
                screen: UIScreen.main
            )
        }
        di.register(type: ElementFinder.self) { di in
            UiKitHierarchyElementFinder(
                ipcClient: try di.resolve(),
                testFailureRecorder: try di.resolve(),
                stepLogger: try di.resolve(),
                screenshotTaker: try di.resolve(),
                signpostActivityLogger: try di.resolve(),
                dateProvider: try di.resolve()
            )
        }
        di.register(type: PageObjectDependenciesFactory.self) { di in
            GrayPageObjectDependenciesFactory(
                testFailureRecorder: try di.resolve(),
                ipcClient: try di.resolve(),
                stepLogger: try di.resolve(),
                pollingConfiguration: .reduceWorkload,
                elementFinder: try di.resolve(),
                screenshotTaker: try di.resolve(),
                windowsProvider: try di.resolve(),
                waiter: try di.resolve(),
                signpostActivityLogger: try di.resolve(),
                snapshotsDifferenceAttachmentGenerator: try di.resolve(),
                snapshotsComparatorFactory: try di.resolve()
            )
        }
    }
}
