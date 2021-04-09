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
            
            testCase.record(
                XCTIssue(
                    type: .assertionFailure,
                    compactDescription: description,
                    detailedDescription: nil,
                    sourceCodeContext: XCTSourceCodeContext(
                        location: XCTSourceCodeLocation(
                            filePath: fileLine?.file ?? #file,
                            lineNumber: fileLine?.line ?? #line
                        )
                    ),
                    associatedError: nil,
                    attachments: []
                )
            )
            
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
