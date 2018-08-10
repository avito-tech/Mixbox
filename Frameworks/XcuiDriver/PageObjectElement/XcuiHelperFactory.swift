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
    
    // MARK: - Init
    init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        keyboardEventInjector: KeyboardEventInjector,
        snapshotsComparisonUtility: SnapshotsComparisonUtility,
        stepLogger: StepLogger)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.elementVisibilityCheckerInstance = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
        self.stepLoggerInstance = stepLogger
        self.keyboardEventInjectorInstance = keyboardEventInjector
        self.elementFinder = ElementFinderImpl(
            stepLogger: stepLogger
        )
    }
    
    // MARK: - EarlGreyHelperFactory
    
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
            scrollingHintsProvider: scrollingHintsProvider
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
}
