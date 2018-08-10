import MixboxUiTestsFoundation
import XCTest
import MixboxTestsFoundation
import MixboxReporting
import MixboxFoundation

final class XcTestFailureRecorder: TestFailureRecorder {
    private let currentTestCaseProvider: CurrentTestCaseProvider
    
    init(currentTestCaseProvider: CurrentTestCaseProvider) {
        self.currentTestCaseProvider = currentTestCaseProvider
    }
    
    func recordFailure(description: String, fileLine: FileLine, shouldContinueTest: Bool) {
        let testCase = currentTestCaseProvider.currentTestCase()
        
        if let testCase = testCase {
            let previousValue = testCase.continueAfterFailure
            testCase.continueAfterFailure = shouldContinueTest
            testCase.recordFailure(
                withDescription: description,
                inFile: String(describing: fileLine.file),
                atLine: Int(fileLine.line),
                // https://developer.apple.com/documentation/xctest/xctestcase/1496269-recordfailure
                // > true if the failure being reported was the result of a failed assertion,
                // > false if it was the result of an uncaught exception.
                // Видимо, false следует применять в случаях, когда вообще не понятно что произошло.
                expected: true
            )
            testCase.continueAfterFailure = previousValue
        } else {
            XCTFail(description, file: fileLine.file, line: fileLine.line)
        }
    }
}
