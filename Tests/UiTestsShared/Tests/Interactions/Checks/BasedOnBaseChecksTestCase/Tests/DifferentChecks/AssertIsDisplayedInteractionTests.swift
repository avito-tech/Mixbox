import MixboxUiTestsFoundation

final class AssertIsDisplayedInteractionTests: BaseChecksTestCase {
    func test___assertIsDisplayed___passes_immediately___if_ui_appears_immediately() {
        check___assert_passes_immediately___if_ui_appears_immediately(passingAssertSpecification())
    }
    
    func test___assertIsDisplayed___fails_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_fails_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    func test___assertIsDisplayed___passes_not_immediately___if_ui_doesnt_appear_immediately() {
        check___assert_passes_not_immediately___if_ui_doesnt_appear_immediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.isDisplayed0 },
            assert: { $0.assertIsDisplayed() }
        )
    }
    
    func test___assertIsDisplayed___failsProperlyIfElementIsNotDisplayed() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что отображается "isNotDisplayed0"" неуспешно, так как: элемент не найден в иерархии
                """,
            body: {
                screen.isNotDisplayed0.withoutTimeout.assertIsDisplayed()
            }
        )
        
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что отображается "isNotDisplayed1"" неуспешно, так как: элемент не найден в иерархии
                """,
            body: {
                screen.isNotDisplayed1.withoutTimeout.assertIsDisplayed()
            }
        )
    }
}
