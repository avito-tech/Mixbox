import MixboxUiTestsFoundation

final class AssertIsEnabledInteractionTests: BaseChecksTestCase {
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
            element: { screen in screen.isEnabled0 },
            assert: { $0.assertIsEnabled() }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertIsEnabled_failsProperlyIfElementIsDisabled() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что "button 'isDisabled0'" доступно для нажатия" неуспешно, так как: проверка неуспешна (Имеет проперти isEnabled: равно true): не равно 'true', актуальное значение: 'false')
                """,
            body: {
                screen.isDisabled0.withoutTimeout.assertIsEnabled()
            }
        )
    }
}
