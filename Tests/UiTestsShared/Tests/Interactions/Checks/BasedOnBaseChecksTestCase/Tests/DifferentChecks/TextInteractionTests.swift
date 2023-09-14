import MixboxUiTestsFoundation
import XCTest

final class TextInteractionTests: BaseChecksTestCase {
    func test___text___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___text___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText0 },
            assert: { XCTAssertEqual($0.text(), "Full match") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___text___fails_properly_if_text_mismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "getting value "text" of visible element "isNotDisplayed0"" failed, because: element was not found in hierarchy
                """,
            body: {
                _ = screen.isNotDisplayed0.withoutTimeout.text()
            }
        )
    }
}
