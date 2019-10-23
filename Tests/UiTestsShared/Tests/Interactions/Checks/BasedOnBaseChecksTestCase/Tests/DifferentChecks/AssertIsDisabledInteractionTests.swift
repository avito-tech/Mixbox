import MixboxUiTestsFoundation

final class AssertIsDisabledInteractionTests: BaseChecksTestCase {
    func test___assertIsDisabled___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertIsDisabled___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertIsDisabled___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<ButtonElement> {
        return AssertSpecification(
            element: { screen in screen.isDisabled0 },
            assert: { $0.assertIsDisabled() }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertIsDisabled___fails_properly_if_element_is_enabled() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что "isEnabled0" недоступно для нажатия" неуспешно, так как: проверка неуспешна (Имеет проперти isEnabled: равно false): не равно 'false', актуальное значение: 'true')
                """,
            body: {
                screen.isEnabled0.withoutTimeout.assertIsDisabled()
            }
        )
    }
}
