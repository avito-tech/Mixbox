import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation
import MixboxInAppServices

// TODO: Share code between black-box and gray-box.
public final class GrayPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    public let elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider
    
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: SynchronousIpcClient
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let elementFinder: ElementFinder
    private let screenshotTaker: ScreenshotTaker
    private let orderedWindowsProvider: OrderedWindowsProvider
    private let waiter: RunLoopSpinningWaiter
    private let signpostActivityLogger: SignpostActivityLogger
    private let grayBoxTestsDependenciesFactory: GrayBoxTestsDependenciesFactory
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: SynchronousIpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        screenshotTaker: ScreenshotTaker,
        orderedWindowsProvider: OrderedWindowsProvider,
        waiter: RunLoopSpinningWaiter,
        signpostActivityLogger: SignpostActivityLogger,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator,
        snapshotsComparatorFactory: SnapshotsComparatorFactory,
        applicationQuiescenceWaiter: ApplicationQuiescenceWaiter,
        applicationWindowsProvider: ApplicationWindowsProvider,
        multiTouchEventFactory: MultiTouchEventFactory,
        elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider,
        keyboardEventInjector: SynchronousKeyboardEventInjector)
    {
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.elementFinder = elementFinder
        self.screenshotTaker = screenshotTaker
        self.orderedWindowsProvider = orderedWindowsProvider
        self.waiter = waiter
        self.signpostActivityLogger = signpostActivityLogger
        self.elementSettingsDefaultsProvider = elementSettingsDefaultsProvider
        
        grayBoxTestsDependenciesFactory = GrayBoxTestsDependenciesFactoryImpl(
            testFailureRecorder: testFailureRecorder,
            elementVisibilityChecker: ElementVisibilityCheckerImpl(
                ipcClient: ipcClient
            ),
            scrollingHintsProvider: ScrollingHintsProviderImpl(
                ipcClient: ipcClient
            ),
            keyboardEventInjector: keyboardEventInjector,
            stepLogger: stepLogger,
            pollingConfiguration: pollingConfiguration,
            elementFinder: elementFinder,
            screenshotTaker: screenshotTaker,
            orderedWindowsProvider: orderedWindowsProvider,
            waiter: waiter,
            signpostActivityLogger: signpostActivityLogger,
            snapshotsDifferenceAttachmentGenerator: snapshotsDifferenceAttachmentGenerator,
            snapshotsComparatorFactory: snapshotsComparatorFactory,
            applicationQuiescenceWaiter: applicationQuiescenceWaiter,
            applicationWindowsProvider: applicationWindowsProvider,
            multiTouchEventFactory: multiTouchEventFactory
        )
    }
    
    public func pageObjectElementCoreFactory() -> PageObjectElementCoreFactory {
        return PageObjectElementCoreFactoryImpl(
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
