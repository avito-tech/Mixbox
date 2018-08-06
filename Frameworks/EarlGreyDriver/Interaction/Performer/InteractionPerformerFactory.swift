import MixboxUiTestsFoundation
import MixboxTestsFoundation

protocol InteractionPerformerFactory {
    func performerForInteraction(
        isCheckForNotDisplayed: Bool,
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
        isCheckForNotDisplayed: Bool,
        shouldReportResultToObserver: Bool)
        -> InteractionPerformer
    {
        let originalInteractionPerformer = isCheckForNotDisplayed
            ? invisiblityCheckInteractionPerformer()
            : interactionPerformer()
        
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
    
    private func interactionPerformer() -> InteractionPerformer {
        return ScrollingInteractionPerformer(
            earlGreyScroller: earlGreyScroller()
        )
    }
    
    private func invisiblityCheckInteractionPerformer() -> InteractionPerformer {
        return InvisibilityCheckingScrollingInteractionPerformer(
            earlGreyScroller: earlGreyScroller()
        )
    }
    
    private func earlGreyScroller() -> EarlGreyScroller {
        return EarlGreyScrollerImpl()
    }
}
