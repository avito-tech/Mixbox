import XCTest
import MixboxTestsFoundation

final class UninterceptableErrorTrackerImpl:
    UninterceptableErrorTracker,
    UninterceptableErrorRecorder
{
    private var trackedErrors: [UninterceptableError] = []
    
    func track(uninterceptableError: UninterceptableError) {
        trackedErrors.append(uninterceptableError)
    }
    
    func recordFailures(testCase: TestCaseSuppressingWarningAboutDeprecatedRecordFailure) {
        trackedErrors.forEach {
            testCase.recordFailureBySuper(
                description: "\($0.error)",
                file: "\($0.fileLine.file)",
                line: $0.fileLine.line,
                expected: false
            )
        }
    }
}
