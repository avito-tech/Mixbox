import MixboxUiTestsFoundation

final class AssertTextMatchesInteractionTests: BaseChecksTestCase {
    func test___assertTextMatches___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertTextMatches___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertTextMatches___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText1 },
            assert: { $0.assertTextMatches("Parti[a-z]+\\W.+(This text doesn't exist|$)") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertTextMatches___fails_properly_if_text_mismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage:
                """
                "check that text in "checkText1" matches regular expression "^not passing regexp$"" failed, because: check failed (has property "text": text matches regular expression "^not passing regexp$"): string doesn't match regular expression '^not passing regexp$', actual string: 'Partial match'
                """,
            body: {
                screen.checkText1.withoutTimeout.assertTextMatches("^not passing regexp$")
            }
        )
    }
}
