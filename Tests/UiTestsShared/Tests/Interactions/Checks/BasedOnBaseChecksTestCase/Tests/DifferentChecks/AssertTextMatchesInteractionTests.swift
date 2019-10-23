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
            assert: { $0.assertTextMatches("Час[а-я]+\\W.+(This text doesn't exist|$)") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertTextMatches___fails_properly_if_text_mismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что в "checkText1" текст соответствует регулярке "^not passing regexp$"" неуспешно, так как: проверка неуспешна (Имеет проперти text: текст соответствует регулярке "^not passing regexp$"): текст не прошел проверку регуляркой '^not passing regexp$', актуальный текст: 'Частичное соответствие'
                """,
            body: {
                screen.checkText1.withoutTimeout.assertTextMatches("^not passing regexp$")
            }
        )
    }
}
