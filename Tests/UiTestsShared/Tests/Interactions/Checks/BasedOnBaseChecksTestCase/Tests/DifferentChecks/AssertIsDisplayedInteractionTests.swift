import MixboxUiTestsFoundation

final class AssertIsDisplayedInteractionTests: BaseChecksTestCase {
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
            element: { screen in screen.isDisplayed0 },
            assert: { $0.assertIsDisplayed() }
        )
    }
    
    func test_assert_failsProperlyIfElementIsNotDisplayed() {
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
