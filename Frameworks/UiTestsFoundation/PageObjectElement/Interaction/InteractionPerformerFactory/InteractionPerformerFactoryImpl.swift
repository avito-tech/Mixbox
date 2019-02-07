import MixboxTestsFoundation
import MixboxReporting

public final class InteractionPerformerFactoryImpl: InteractionPerformerFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func performerForInteraction(
        shouldReportResultToObserver: Bool)
        -> InteractionPerformer
    {
        let originalInteractionPerformer = InteractionPerformerImpl()
        
        if shouldReportResultToObserver {
            return LoggingInteractionPerformer(
                wrappedInteractionPerformer: originalInteractionPerformer,
                interactionExecutionLogger: interactionExecutionLogger,
                testFailureRecorder: testFailureRecorder
            )
        } else {
            return originalInteractionPerformer
        }
    }
}
