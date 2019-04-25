import MixboxUiTestsFoundation

final class AssertTextMatchesInteractionTests: BaseChecksTestCase {
    func test_assert_passes_immediately_ifUiAppearsImmediately() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification())
    }
    
    func test_assert_fails_immediately_ifUiDoesntAppearImmediately() {
        checkAssert_fails_immediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    func test_assert_passes_notImmediately_ifUiDoesntAppearImmediately() {
        checkAssert_passes_notImmediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText1 },
            assert: { $0.assertTextMatches("Час[а-я]+\\W.+(This text doesn't exist|$)") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertTextMatches_failsProperlyIfTextMismatches() {
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
