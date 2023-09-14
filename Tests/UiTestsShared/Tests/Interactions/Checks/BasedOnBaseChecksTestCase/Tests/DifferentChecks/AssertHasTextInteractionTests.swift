import MixboxUiTestsFoundation

final class AssertHasTextInteractionTests: BaseChecksTestCase {
    func test___assertHasText___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertHasText___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertHasText___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText0 },
            assert: { $0.assertHasText("Full match") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertHasText___failsProperly() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "check that text in "checkText0" is equal to "Full [check shall not pass] match"" failed, because: check failed (has property "text": equals to Full [check shall not pass] match): value is not equal to 'Full [check shall not pass] match', actual value: 'Full match'
                """,
            body: {
                screen.checkText0.withoutTimeout.assertHasText("Full [check shall not pass] match")
            }
        )
    }
}
