import MixboxTestsFoundation
import MixboxUiTestsFoundation
import MixboxIpcClients
import MixboxReporting

protocol XcuiHelperFactory: class {
    var snapshotsComparisonUtility: SnapshotsComparisonUtility { get }

    func stepLogger() -> StepLogger
    func interactionPerformerFactory() -> InteractionPerformerFactory
    func interactionFactory() -> InteractionFactory
    func elementVisibilityChecker() -> ElementVisibilityChecker
    func keyboardEventInjector() -> KeyboardEventInjector
    func pollingConfiguration() -> PollingConfiguration
}

final class XcuiHelperFactoryImpl: XcuiHelperFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    private let elementVisibilityCheckerInstance: ElementVisibilityChecker
    private let stepLoggerInstance: StepLogger
    private let elementFinder: ElementFinder
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let keyboardEventInjectorInstance: KeyboardEventInjector
    let snapshotsComparisonUtility: SnapshotsComparisonUtility
    private let pollingConfigurationValue: PollingConfiguration
    private let snapshotCaches: SnapshotCaches
    
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
        snapshotCaches: SnapshotCaches,
        elementFinder: ElementFinder)
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
        self.snapshotCaches = snapshotCaches
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
            snapshotCaches: snapshotCaches
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
