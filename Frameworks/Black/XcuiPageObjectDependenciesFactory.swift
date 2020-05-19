import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxFoundation

public final class XcuiPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: SynchronousIpcClient
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let elementFinder: ElementFinder
    private let applicationProvider: ApplicationProvider
    private let eventGenerator: EventGenerator
    private let screenshotTaker: ScreenshotTaker
    private let pasteboard: Pasteboard
    private let runLoopSpinningWaiter: RunLoopSpinningWaiter
    private let signpostActivityLogger: SignpostActivityLogger
    private let snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator
    private let snapshotsComparatorFactory: SnapshotsComparatorFactory
    private let xcuiBasedTestsDependenciesFactory: XcuiBasedTestsDependenciesFactory
    public let elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: SynchronousIpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        eventGenerator: EventGenerator,
        screenshotTaker: ScreenshotTaker,
        pasteboard: Pasteboard,
        runLoopSpinningWaiter: RunLoopSpinningWaiter,
        signpostActivityLogger: SignpostActivityLogger,
        snapshotsDifferenceAttachmentGenerator: SnapshotsDifferenceAttachmentGenerator,
        snapshotsComparatorFactory: SnapshotsComparatorFactory,
        applicationQuiescenceWaiter: ApplicationQuiescenceWaiter,
        elementSettingsDefaultsProvider: ElementSettingsDefaultsProvider,
        keyboardEventInjector: SynchronousKeyboardEventInjector)
    {
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.elementFinder = elementFinder
        self.applicationProvider = applicationProvider
        self.eventGenerator = eventGenerator
        self.screenshotTaker = screenshotTaker
        self.pasteboard = pasteboard
        self.runLoopSpinningWaiter = runLoopSpinningWaiter
        self.signpostActivityLogger = signpostActivityLogger
        self.snapshotsDifferenceAttachmentGenerator = snapshotsDifferenceAttachmentGenerator
        self.snapshotsComparatorFactory = snapshotsComparatorFactory
        self.elementSettingsDefaultsProvider = elementSettingsDefaultsProvider
        
        xcuiBasedTestsDependenciesFactory = XcuiBasedTestsDependenciesFactoryImpl(
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
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: ApplicationCoordinatesProviderImpl(
                applicationProvider: applicationProvider,
                applicationFrameProvider: XcuiApplicationFrameProvider(
                    applicationProvider: applicationProvider
                )
            ),
            eventGenerator: eventGenerator,
            screenshotTaker: screenshotTaker,
            pasteboard: pasteboard,
            runLoopSpinningWaiter:runLoopSpinningWaiter,
            signpostActivityLogger: signpostActivityLogger,
            snapshotsDifferenceAttachmentGenerator: snapshotsDifferenceAttachmentGenerator,
            snapshotsComparatorFactory: snapshotsComparatorFactory,
            applicationQuiescenceWaiter: applicationQuiescenceWaiter
        )
    }
    
    public func pageObjectElementCoreFactory() -> PageObjectElementCoreFactory {
        return PageObjectElementCoreFactoryImpl(
            testFailureRecorder: xcuiBasedTestsDependenciesFactory.testFailureRecorder,
            screenshotAttachmentsMaker: xcuiBasedTestsDependenciesFactory.screenshotAttachmentsMaker,
            stepLogger: xcuiBasedTestsDependenciesFactory.stepLogger,
            dateProvider: xcuiBasedTestsDependenciesFactory.dateProvider,
            elementInteractionDependenciesFactory: { [xcuiBasedTestsDependenciesFactory] elementSettings in
                XcuiElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    xcuiBasedTestsDependenciesFactory: xcuiBasedTestsDependenciesFactory
                )
            },
            signpostActivityLogger: signpostActivityLogger
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return xcuiBasedTestsDependenciesFactory.elementMatcherBuilder
    }
}
