import MixboxTestsFoundation
import MixboxFoundation
import MixboxUiTestsFoundation

final class FailingElementFinder: ElementFinder {
    private let testFailureRecorder: TestFailureRecorder
    private let message: String
    
    init(
        testFailureRecorder: TestFailureRecorder,
        message: String)
    {
        self.testFailureRecorder = testFailureRecorder
        self.message = message
    }
    
    func query(
        elementMatcher: ElementMatcher,
        elementFunctionDeclarationLocation: FunctionDeclarationLocation)
        -> ElementQuery
    {
        return FailingElementQuery(
            testFailureRecorder: testFailureRecorder,
            message: message
        )
    }
}
