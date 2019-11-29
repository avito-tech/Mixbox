import XCTest
import MixboxFoundation

public final class XcTestFailureRecorder: TestFailureRecorder {
    private let currentTestCaseProvider: CurrentTestCaseProvider
    private let shouldNeverContinueTestAfterFailure: Bool
    
    // If `shouldNeverContinueTestAfterFailure` then `shouldContinueTest` is ignored.
    // Consider using `false` for debugging tests and `true` for CI builds.
    public init(
        currentTestCaseProvider: CurrentTestCaseProvider,
        shouldNeverContinueTestAfterFailure: Bool)
    {
        self.currentTestCaseProvider = currentTestCaseProvider
        self.shouldNeverContinueTestAfterFailure = shouldNeverContinueTestAfterFailure
    }
    
    public func recordFailure(description: String, fileLine: FileLine?, shouldContinueTest: Bool) {
        let testCase = currentTestCaseProvider.currentTestCase()
        
        if let testCase = testCase {
            let previousValue = testCase.continueAfterFailure
            testCase.continueAfterFailure = shouldNeverContinueTestAfterFailure ? false : shouldContinueTest
            testCase.recordFailure(
                withDescription: description,
                inFile: String(describing: fileLine?.file ?? #file),
                atLine: Int(fileLine?.line ?? #line),
                // https://developer.apple.com/documentation/xctest/xctestcase/1496269-recordfailure
                // > true if the failure being reported was the result of a failed assertion,
                // > false if it was the result of an uncaught exception.
                // Perhaps we should use `false` in cases when we don't know what happened.
                expected: true
            )
            testCase.continueAfterFailure = previousValue
        } else {
            // TODO: Invent a way to report errors to developers.
            // Logs can be easily ignored.
            print(
                """
                ERROR: failure was recorded, but current XCTestCase was not found \
                (e.g. all tests were already executed), \
                failure description: \(description) \
                file: \(fileLine?.file ?? #file) \
                line: \(fileLine?.line ?? #line)
                """
            )
        }
    }
}
