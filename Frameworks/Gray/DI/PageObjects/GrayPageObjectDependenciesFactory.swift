import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpc
import MixboxReporting

// TODO: Share code between black-box and gray-box.
public final class GrayPageObjectDependenciesFactory: PageObjectDependenciesFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let ipcClient: IpcClient
    private let stepLogger: StepLogger
    private let pollingConfiguration: PollingConfiguration
    private let elementFinder: ElementFinder
    private let screenshotTaker: ScreenshotTaker
    private let windowsProvider: WindowsProvider
    private let spinner: Spinner
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        ipcClient: IpcClient,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        screenshotTaker: ScreenshotTaker,
        windowsProvider: WindowsProvider,
        spinner: Spinner)
    {
        self.testFailureRecorder = testFailureRecorder
        self.ipcClient = ipcClient
        self.stepLogger = stepLogger
        self.pollingConfiguration = pollingConfiguration
        self.elementFinder = elementFinder
        self.screenshotTaker = screenshotTaker
        self.windowsProvider = windowsProvider
        self.spinner = spinner
    }
    
    public func pageObjectElementFactory() -> PageObjectElementFactory {
        let grayBoxTestsDependenciesFactory = GrayBoxTestsDependenciesFactoryImpl(
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
            screenshotTaker: screenshotTaker,
            windowsProvider: windowsProvider,
            spinner: spinner
        )
        
        return PageObjectElementFactoryImpl(
            testFailureRecorder: grayBoxTestsDependenciesFactory.testFailureRecorder,
            screenshotAttachmentsMaker: grayBoxTestsDependenciesFactory.screenshotAttachmentsMaker,
            stepLogger: grayBoxTestsDependenciesFactory.stepLogger,
            dateProvider: grayBoxTestsDependenciesFactory.dateProvider,
            elementInteractionDependenciesFactory: { elementSettings in
                GrayElementInteractionDependenciesFactory(
                    elementSettings: elementSettings,
                    grayBoxTestsDependenciesFactory: grayBoxTestsDependenciesFactory
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
