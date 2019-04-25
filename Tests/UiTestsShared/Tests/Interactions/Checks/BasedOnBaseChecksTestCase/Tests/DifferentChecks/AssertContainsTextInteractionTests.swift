import MixboxUiTestsFoundation

final class AssertContainsTextInteractionTests: BaseChecksTestCase {
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
            element: { screen in screen.checkText1 },
            assert: { $0.assertContainsText("Частичное соотве") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertContainsText_failsProperlyIfTextMismatches() {
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
