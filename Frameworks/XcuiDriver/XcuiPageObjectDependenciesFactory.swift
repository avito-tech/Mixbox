import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxReporting
import MixboxFoundation

public final class XcuiPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: IpcClient
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let elementFinder: ElementFinder
    private let applicationProvider: ApplicationProvider
    private let eventGenerator: EventGenerator
    private let screenshotTaker: ScreenshotTaker
    private let pasteboard: Pasteboard
    private let waiter: RunLoopSpinningWaiter
    private let signpostActivityLogger: SignpostActivityLogger
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        eventGenerator: EventGenerator,
        screenshotTaker: ScreenshotTaker,
        pasteboard: Pasteboard,
        waiter: RunLoopSpinningWaiter,
        signpostActivityLogger: SignpostActivityLogger)
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
        self.waiter = waiter
        self.signpostActivityLogger = signpostActivityLogger
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        let xcuiBasedTestsDependenciesFactory = XcuiBasedTestsDependenciesFactoryImpl(
            testFailureRecorder: testFailureRecorder,
            elementVisibilityChecker: ElementVisibilityCheckerImpl(
                ipcClient: ipcClient
            ),
            scrollingHintsProvider: ScrollingHintsProviderImpl(
                ipcClient: ipcClient
            ),
            keyboardEventInjector: KeyboardEventInjectorImpl(
                ipcClient: ipcClient
            ),
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
            waiter: waiter,
            signpostActivityLogger: signpostActivityLogger
        )
        
        return PageObjectElementFactoryImpl(
            testFailureRecorder: xcuiBasedTestsDependenciesFactory.testFailureRecorder,
            screenshotAttachmentsMaker: xcuiBasedTestsDependenciesFactory.screenshotAttachmentsMaker,
            stepLogger: xcuiBasedTestsDependenciesFactory.stepLogger,
            dateProvider: xcuiBasedTestsDependenciesFactory.dateProvider,
            elementInteractionDependenciesFactory: { elementSettings in
                XcuiElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    xcuiBasedTestsDependenciesFactory: xcuiBasedTestsDependenciesFactory
                )
            },
            signpostActivityLogger: signpostActivityLogger
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: screenshotTaker
        )
    }
}
