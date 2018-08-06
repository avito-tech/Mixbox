import MixboxTestsFoundation
import MixboxUiTestsFoundation

protocol EarlGreyHelperFactory: class {
    var snapshotsComparisonUtility: SnapshotsComparisonUtility { get }
    
    func interactionPerformerFactory() -> InteractionPerformerFactory
    func interactionFactory() -> InteractionFactory
}

final class EarlGreyHelperFactoryImpl: EarlGreyHelperFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    let snapshotsComparisonUtility: SnapshotsComparisonUtility
    
    // MARK: - Init
    init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        snapshotsComparisonUtility: SnapshotsComparisonUtility
        )
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
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
            predicateNodeToEarlGreyMatcherConverter: predicateNodeToEarlGreyMatcherConverter()
        )
    }
    
    // MARK: - Private
    
    private func predicateNodeToEarlGreyMatcherConverter() -> PredicateNodeToEarlGreyMatcherConverter {
        return PredicateNodeToEarlGreyMatcherConverterImpl()
    }
}
