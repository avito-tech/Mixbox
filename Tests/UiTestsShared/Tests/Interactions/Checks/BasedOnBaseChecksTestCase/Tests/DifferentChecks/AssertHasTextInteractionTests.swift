import MixboxUiTestsFoundation

final class AssertHasTextInteractionTests: BaseChecksTestCase {
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
            element: { screen in screen.checkText0 },
            assert: { $0.assertHasText("Полное соответствие") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assert_failsProperly() {
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
