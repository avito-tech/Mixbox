import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxTestsFoundation

final class FailingElementQuery: ElementQuery {
    private let testFailureRecorder: TestFailureRecorder
    private let message: String
    
    init(testFailureRecorder: TestFailureRecorder, message: String) {
        self.testFailureRecorder = testFailureRecorder
        self.message = message
    }
    
    func resolveElement(interactionMode: InteractionMode) -> ResolvedElementQuery {
        testFailureRecorder.recordFailure(
            description: message,
            fileLine: FileLine.current(), // TODO: Better FileLine
            shouldContinueTest: false
        )
        
        return ResolvedElementQuery(elementQueryResolvingState: ElementQueryResolvingState())
    }
}
