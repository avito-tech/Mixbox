import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxReporting

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
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        eventGenerator: EventGenerator,
        screenshotTaker: ScreenshotTaker,
        pasteboard: Pasteboard)
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
            pasteboard: pasteboard
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
            }
        )
    }
    
    public func matcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: screenshotTaker
        )
    }
}
