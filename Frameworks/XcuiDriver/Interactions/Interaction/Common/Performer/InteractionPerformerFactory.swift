import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxReporting

protocol InteractionPerformerFactory {
    func performerForInteraction(
        shouldReportResultToObserver: Bool)
        -> InteractionPerformer
}

final class InteractionPerformerFactoryImpl: InteractionPerformerFactory {
    private let interactionExecutionLogger: InteractionExecutionLogger
    private let testFailureRecorder: TestFailureRecorder
    
    init(
        interactionExecutionLogger: InteractionExecutionLogger,
        testFailureRecorder: TestFailureRecorder)
    {
        self.interactionExecutionLogger = interactionExecutionLogger
        self.testFailureRecorder = testFailureRecorder
    }
    
    func performerForInteraction(
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
