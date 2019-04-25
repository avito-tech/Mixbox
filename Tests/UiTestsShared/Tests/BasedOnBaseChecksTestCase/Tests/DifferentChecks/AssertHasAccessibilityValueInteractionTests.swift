import MixboxUiTestsFoundation

final class AssertHasAccessibilityValueInteractionTests: BaseChecksTestCase {
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
            element: { screen in screen.hasValue0 },
            assert: { $0.assertHasAccessibilityValue("Accessibility Value") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertHasAccessibilityValue_failsProperlyIfAccessibilityValueMismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что в "hasValue0" accessibility value = Accessibility [check shall not pass] Value" неуспешно, так как: проверка неуспешна (Имеет проперти value: равно Accessibility [check shall not pass] Value): не равно 'Accessibility [check shall not pass] Value', актуальное значение: 'Accessibility Value')
                """,
            body: {
                screen.hasValue0
                    .withoutTimeout
                    .assertHasAccessibilityValue("Accessibility [check shall not pass] Value")
            }
        )
    }
}
