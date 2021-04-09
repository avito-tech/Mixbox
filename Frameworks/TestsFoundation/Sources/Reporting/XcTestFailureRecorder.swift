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
            let continueAfterFailureOldValue = testCase.continueAfterFailure
            let continueAfterFailureNewValue = shouldNeverContinueTestAfterFailure ? false : shouldContinueTest
            
            testCase.continueAfterFailure = continueAfterFailureNewValue
            
            testCase.recordFailureBySelf(
                description: description,
                file: String(describing: fileLine?.file ?? #file),
                line: fileLine?.line ?? #line,
                // https://developer.apple.com/documentation/xctest/xctestcase/1496269-recordfailure
                // > true if the failure being reported was the result of a failed assertion,
                // > false if it was the result of an uncaught exception.
                // Perhaps we should use `false` in cases when we don't know what happened.
                expected: true
            )
            
            if !continueAfterFailureNewValue {
                // In this case test should be interrupted. However, since Xcode 12 something is broken.
                // I though this is because we override `recordFailure`, but I removed the overriding
                // and still had this issue. The following line is a workaround. It forcefully triggers an
                // interruption. Maybe it can be fixed properly, but it already took 1 day debugging and
                // disassembling.
                testCase._interruptOrMarkForLaterInterruption()
            }
            
            testCase.continueAfterFailure = continueAfterFailureOldValue
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
