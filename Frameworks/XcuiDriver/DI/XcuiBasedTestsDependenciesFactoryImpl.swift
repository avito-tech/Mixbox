import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxReporting

final class XcuiBasedTestsDependenciesFactoryImpl: XcuiBasedTestsDependenciesFactory {
    let applicationProvider: ApplicationProvider
    let applicationFrameProvider: ApplicationFrameProvider
    let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    let eventGenerator: EventGenerator
    let testFailureRecorder: TestFailureRecorder
    let elementVisibilityChecker: ElementVisibilityChecker
    let stepLogger: StepLogger
    let elementFinder: ElementFinder
    let scrollingHintsProvider: ScrollingHintsProvider
    let keyboardEventInjector: KeyboardEventInjector
    let pollingConfiguration: PollingConfiguration
    let screenshotTaker: ScreenshotTaker
    let pasteboard: Pasteboard
    
    // MARK: - Init
    
    init(
        testFailureRecorder: TestFailureRecorder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        keyboardEventInjector: KeyboardEventInjector,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        eventGenerator: EventGenerator,
        screenshotTaker: ScreenshotTaker,
        pasteboard: Pasteboard)
    {
        self.testFailureRecorder = testFailureRecorder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.stepLogger = stepLogger
        self.keyboardEventInjector = keyboardEventInjector
        self.elementFinder = elementFinder
        self.pollingConfiguration = pollingConfiguration
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.eventGenerator = eventGenerator
        self.screenshotTaker = screenshotTaker
        self.pasteboard = pasteboard
        
        applicationFrameProvider = XcuiApplicationFrameProvider(
            applicationProvider: applicationProvider
        )
    }
    
    // MARK: - XcuiBasedTestsDependenciesFactory
    
    var retrier: Retrier {
        return RetrierImpl(
            pollingConfiguration: pollingConfiguration
        )
    }
    
    var elementMatcherBuilder: ElementMatcherBuilder {
        return ElementMatcherBuilder(
            screenshotTaker: screenshotTaker
        )
    }
    
    var screenshotAttachmentsMaker: ScreenshotAttachmentsMaker {
        return ScreenshotAttachmentsMakerImpl(
            imageHashCalculator: DHashV0ImageHashCalculator(),
            screenshotTaker: screenshotTaker
        )
    }
    
    var dateProvider: DateProvider {
        return SystemClockDateProvider()
    }
}
