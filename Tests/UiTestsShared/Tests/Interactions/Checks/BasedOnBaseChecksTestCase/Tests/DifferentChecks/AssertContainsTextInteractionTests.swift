import MixboxUiTestsFoundation

final class AssertContainsTextInteractionTests: BaseChecksTestCase {
    func test___assertContainsText___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertContainsText___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertContainsText___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText1 },
            assert: { $0.assertContainsText("Partial ma") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertContainsText___failsProperlyIfTextMismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "check that "checkText1" contains text "Partial [check shall not pass] ma"" failed, because: check failed (has property "text": contains string "Partial [check shall not pass] ma"): expected that given string contains 'Partial [check shall not pass] ma', but given string is equal to 'Partial match'
                """,
            body: {
                screen.checkText1.withoutTimeout.assertContainsText("Partial [check shall not pass] ma")
            }
        )
    }
}
