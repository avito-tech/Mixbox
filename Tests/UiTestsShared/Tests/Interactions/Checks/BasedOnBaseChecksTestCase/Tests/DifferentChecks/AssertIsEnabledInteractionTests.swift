import MixboxUiTestsFoundation

final class AssertIsEnabledInteractionTests: BaseChecksTestCase {
    func test___assertIsEnabled___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertIsEnabled___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertIsEnabled___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<ButtonElement> {
        return AssertSpecification(
            element: { screen in screen.isEnabled0 },
            assert: { $0.assertIsEnabled() }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertIsEnabled___failsProperlyIfElementIsDisabled() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "check that "isDisabled0" is enabled" failed, because: check failed (has property "isEnabled": equals to true): value is not equal to 'true', actual value: 'false'
                """,
            body: {
                screen.isDisabled0.withoutTimeout.assertIsEnabled()
            }
        )
    }
}
