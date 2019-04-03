import MixboxUiTestsFoundation

final class AssertIsDisabledInteractionTests: BaseChecksTestCase {
    func test_assert_passes_immediately_ifUiAppearsImmediately() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification())
    }
    
    func test_assert_fails_immediately_ifUiDoesntAppearImmediately() {
        checkAssert_fails_immediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    func test_assert_passes_notImmediately_ifUiDoesntAppearImmediately() {
        checkAssert_passes_notImmediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<ButtonElement> {
        return AssertSpecification(
            element: { screen in screen.isDisabled0 },
            assert: { $0.assertIsDisabled() }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertIsDisabled_failsProperlyIfElementIsEnabled() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что "button 'isEnabled0'" недоступно для нажатия" неуспешно, так как: проверка неуспешна (Имеет проперти isEnabled: равно false): не равно 'false', актуальное значение: 'true')
                """,
            body: {
                screen.isEnabled0.withoutTimeout.assertIsDisabled()
            }
        )
    }
}
