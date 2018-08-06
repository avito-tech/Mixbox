import MixboxUiTestsFoundation
import MixboxTestsFoundation

public final class EarlGreyPageObjectsDependenciesFactory: PageObjectsDependenciesFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    private let snapshotsComparisonUtility: SnapshotsComparisonUtility
    
    public init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder,
        snapshotsComparisonUtility: SnapshotsComparisonUtility)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
        self.snapshotsComparisonUtility = snapshotsComparisonUtility
    }

    public func pageObjectElementFactory() -> PageObjectElementFactory {
        return EarlGreyPageObjectElementFactory(
            earlGreyHelperFactory: EarlGreyHelperFactoryImpl(
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder,
                snapshotsComparisonUtility: snapshotsComparisonUtility
            )
        )
    }
}
