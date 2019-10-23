import MixboxUiTestsFoundation

final class AssertContainsTextInteractionTests: BaseChecksTestCase {
    func test___assertContainsText___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertContainsText___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertContainsText___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText1 },
            assert: { $0.assertContainsText("Частичное соотве") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertContainsText___failsProperlyIfTextMismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что в "checkText1" содержится текст "Частичное [check shall not pass] соотве"" неуспешно, так как: проверка неуспешна (Имеет проперти text: содержит строку "Частичное [check shall not pass] соотве"): ожидалось содержание 'Частичное [check shall not pass] соотве' в строке, которая по факту равна 'Частичное соответствие'
                """,
            body: {
                screen.checkText1.withoutTimeout.assertContainsText("Частичное [check shall not pass] соотве")
            }
        )
    }
}
