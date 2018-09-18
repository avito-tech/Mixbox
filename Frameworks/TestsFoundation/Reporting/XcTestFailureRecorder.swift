import XCTest
import MixboxFoundation
import MixboxReporting

public final class XcTestFailureRecorder: TestFailureRecorder {
    private let currentTestCaseProvider: CurrentTestCaseProvider
    private let everyErrorShouldFailTest: Bool
    
    public init(currentTestCaseProvider: CurrentTestCaseProvider, everyErrorShouldFailTest: Bool = false) {
        self.currentTestCaseProvider = currentTestCaseProvider
        self.everyErrorShouldFailTest = everyErrorShouldFailTest
    }
    
    public func recordFailure(description: String, fileLine: FileLine?, shouldContinueTest: Bool) {
        let testCase = currentTestCaseProvider.currentTestCase()
        
        if let testCase = testCase {
            let previousValue = testCase.continueAfterFailure
            testCase.continueAfterFailure = everyErrorShouldFailTest ? false : shouldContinueTest
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
            XCTFail(description, file: fileLine?.file ?? #file, line: fileLine?.line ?? #line)
        }
    }
}
