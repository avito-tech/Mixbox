import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation

// TODO: Share code between black-box and gray-box.
public final class GrayPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: IpcClient
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let elementFinder: ElementFinder
    private let screenshotTaker: ScreenshotTaker
    private let windowsProvider: WindowsProvider
    private let waiter: RunLoopSpinningWaiter
    private let signpostActivityLogger: SignpostActivityLogger
    private let grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        screenshotTaker: ScreenshotTaker,
        windowsProvider: WindowsProvider,
        waiter: RunLoopSpinningWaiter,
        signpostActivityLogger: SignpostActivityLogger,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator,
        snapshotsComparatorFactory: SnapshotsComparatorFactory,
        applicationQuiescenceWaiter: ApplicationQuiescenceWaiter)
    {
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.elementFinder = elementFinder
        self.screenshotTaker = screenshotTaker
        self.windowsProvider = windowsProvider
        self.waiter = waiter
        self.signpostActivityLogger = signpostActivityLogger
        
        grayBoxTestsDependenciesFactory = GrayBoxTestsDependenciesFactoryImpl(
            testFailureRecorder: testFailureRecorder,
            elementVisibilityChecker: ElementVisibilityCheckerImpl(
                ipcClient: ipcClient
            ),
            scrollingHintsProvider: ScrollingHintsProviderImpl(
                ipcClient: ipcClient
            ),
            keyboardEventInjector: IpcKeyboardEventInjector(
                ipcClient: ipcClient
            ),
            stepLogger: stepLogger,
            pollingConfiguration: pollingConfiguration,
            elementFinder: elementFinder,
            screenshotTaker: screenshotTaker,
            windowsProvider: windowsProvider,
            waiter: waiter,
            signpostActivityLogger: signpostActivityLogger,
            snapshotsDifferenceAttachmentGenerator: snapshotsDifferenceAttachmentGenerator,
            snapshotsComparatorFactory: snapshotsComparatorFactory,
            applicationQuiescenceWaiter: applicationQuiescenceWaiter
        )
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        return PageObjectElementFactoryImpl(
            testFailureRecorder: grayBoxTestsDependenciesFactory.testFailureRecorder,
            screenshotAttachmentsMaker: grayBoxTestsDependenciesFactory.screenshotAttachmentsMaker,
            stepLogger: grayBoxTestsDependenciesFactory.stepLogger,
            dateProvider: grayBoxTestsDependenciesFactory.dateProvider,
            elementInteractionDependenciesFactory: { [grayBoxTestsDependenciesFactory] elementSettings in
                GrayElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    grayBoxTestsDependenciesFactory: grayBoxTestsDependenciesFactory
                )
            },
            signpostActivityLogger: signpostActivityLogger
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return grayBoxTestsDependenciesFactory.elementMatcherBuilder
    }
}
