import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpcClients
import MixboxReporting

protocol XcuiHelperFactory: class {
    var eventGenerator: EventGenerator { get }
    var applicationProvider: ApplicationProvider { get }
    var applicationCoordinatesProvider: ApplicationCoordinatesProvider { get }
    
    func stepLogger() -> StepLogger
    func interactionPerformerFactory() -> InteractionPerformerFactory
    func interactionFactory() -> InteractionFactory
    func elementVisibilityChecker() -> ElementVisibilityChecker
    func keyboardEventInjector() -> KeyboardEventInjector
    func elementMatcherBuilder() -> ElementMatcherBuilder
}

final class XcuiHelperFactoryImpl: XcuiHelperFactory {
    let applicationProvider: ApplicationProvider
    let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    let eventGenerator: EventGenerator
    
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    private let elementVisibilityCheckerInstance: ElementVisibilityChecker
    private let stepLoggerInstance: StepLogger
    private let elementFinder: ElementFinder
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let keyboardEventInjectorInstance: KeyboardEventInjector
    private let screenshotTaker: ScreenshotTaker
    private let pollingConfiguration: PollingConfiguration
    
    // MARK: - Init
    init(
        interactionExecutionLogger: InteractionExecutionLogger,
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
        screenshotTaker: ScreenshotTaker)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.elementVisibilityCheckerInstance = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.stepLoggerInstance = stepLogger
        self.keyboardEventInjectorInstance = keyboardEventInjector
        self.elementFinder = elementFinder
        self.pollingConfiguration = pollingConfiguration
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.eventGenerator = eventGenerator
        self.screenshotTaker = screenshotTaker
    }
    
    // MARK: - XcuiHelperFactory
    
    func interactionPerformerFactory() -> InteractionPerformerFactory {
        return InteractionPerformerFactoryImpl(
            interactionExecutionLogger: interactionExecutionLogger,
            testFailureRecorder: testFailureRecorder
        )
    }
    
    func interactionFactory() -> InteractionFactory {
        return InteractionFactoryImpl(
            elementFinder: elementFinder,
            elementVisibilityChecker: elementVisibilityCheckerInstance,
            scrollingHintsProvider: scrollingHintsProvider,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider,
            pollingConfiguration: pollingConfiguration
        )
    }
    
    func elementVisibilityChecker() -> ElementVisibilityChecker {
        return elementVisibilityCheckerInstance
    }
    
    func keyboardEventInjector() -> KeyboardEventInjector {
        return keyboardEventInjectorInstance
    }
    
    func stepLogger() -> StepLogger {
        return stepLoggerInstance
    }
    
    func elementMatcherBuilder() -> ElementMatcherBuilder {
        return ElementMatcherBuilder(screenshotTaker: screenshotTaker)
    }
}
