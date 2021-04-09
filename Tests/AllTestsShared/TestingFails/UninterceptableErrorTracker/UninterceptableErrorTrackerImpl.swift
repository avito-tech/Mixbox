import XCTest
import MixboxTestsFoundation

final class UninterceptableErrorTrackerImpl:
    UninterceptableErrorTracker,
    UninterceptableErrorRecorder
{
    private let testFailureRecorder: TestFailureRecorder
    
    private var trackedErrors: [UninterceptableError] = []
    
    public init(testFailureRecorder: TestFailureRecorder) {
        self.testFailureRecorder = testFailureRecorder
    }
    
    func track(uninterceptableError: UninterceptableError) {
        trackedErrors.append(uninterceptableError)
    }
    
    func recordFailures(testCase: XCTestCase) {
        trackedErrors.forEach {
            testFailureRecorder.recordFailure(
                description: "\($0.error)",
                fileLine: $0.fileLine,
                shouldContinueTest: true
            )
        }
    }
}
