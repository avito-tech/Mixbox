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
            assert: { $0.assertHasText("Полное соответствие") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertHasText___failsProperly() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что в "checkText0" текст равен "Полное [check shall not pass] соответствие"" неуспешно, так как: проверка неуспешна (Имеет проперти text: равно Полное [check shall not pass] соответствие): не равно 'Полное [check shall not pass] соответствие', актуальное значение: 'Полное соответствие')
                """,
            body: {
                screen.checkText0.withoutTimeout.assertHasText("Полное [check shall not pass] соответствие")
            }
        )
    }
}
