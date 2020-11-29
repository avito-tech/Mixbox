import XCTest
import MixboxTestsFoundation

final class RecordIssueIsOverridenByRecordFailureTests: TestCaseSuppressingWarningAboutDeprecatedRecordFailure {
    var recordedFailureDescription: String?
    var shouldRecordInsteadOfFailintTest: Bool = false
    
    func test() {
        #if swift(>=5.3)
        shouldRecordInsteadOfFailintTest = true
        
        // Currently `record(_: XCTIssue)` is implemented by calling `recordFailure`.
        // If this changes, then a lot of tests will be false-positive. This is critical.
        // After this will be changed.
        record(
            XCTIssue(type: .assertionFailure, compactDescription: "description")
        )
        
        shouldRecordInsteadOfFailintTest = false
        
        XCTAssertEqual(recordedFailureDescription, "description")
        
        // Uncomment this to ensure that tests works correctly
        // XCTAssertEqual(recordedFailureDescription, "incorrect_description")
        #endif
    }
    
    override func recordFailure(withDescription description: String, inFile file: String, atLine line: Int, expected: Bool) {
        if shouldRecordInsteadOfFailintTest {
            recordedFailureDescription = description
        } else {
            recordFailureBySuper(
                description: description,
                file: file,
                line: UInt(exactly: line) ?? 0,
                expected: expected
            )
        }
    }
}
