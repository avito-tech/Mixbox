import MixboxUiTestsFoundation

final class AssertHasAccessibilityValueInteractionTests: BaseChecksTestCase {
    func test___assertHasAccessibilityValue___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertHasAccessibilityValue___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertHasAccessibilityValue___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.hasValue0 },
            assert: { $0.assertHasAccessibilityValue("Accessibility Value") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertHasAccessibilityValue___failsProperlyIfAccessibilityValueMismatches() {
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
