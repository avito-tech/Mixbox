import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpcClients
import MixboxReporting

protocol XcuiHelperFactory: class {
    var snapshotsComparisonUtility: SnapshotsComparisonUtility { get }
    var eventGenerator: EventGenerator { get }
    var applicationProvider: ApplicationProvider { get }
    var applicationCoordinatesProvider: ApplicationCoordinatesProvider { get }
    
    func stepLogger() -> StepLogger
    func interactionPerformerFactory() -> InteractionPerformerFactory
    func interactionFactory() -> InteractionFactory
    func elementVisibilityChecker() -> ElementVisibilityChecker
    func keyboardEventInjector() -> KeyboardEventInjector
    func pollingConfiguration() -> PollingConfiguration
}

final class XcuiHelperFactoryImpl: XcuiHelperFactory {
    let snapshotsComparisonUtility: SnapshotsComparisonUtility
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
    private let pollingConfigurationValue: PollingConfiguration
    
    // MARK: - Init
    init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        keyboardEventInjector: KeyboardEventInjector,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger,
        pollingConfiguration: PollingConfiguration,
        elementFinder: ElementFinder,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        eventGenerator: EventGenerator)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.elementVisibilityCheckerInstance = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLoggerInstance = stepLogger
        self.keyboardEventInjectorInstance = keyboardEventInjector
        self.elementFinder = elementFinder
        self.pollingConfigurationValue = pollingConfiguration
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.eventGenerator = eventGenerator
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
            applicationCoordinatesProvider: applicationCoordinatesProvider
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
    
    func pollingConfiguration() -> PollingConfiguration {
        return pollingConfigurationValue
    }
}
