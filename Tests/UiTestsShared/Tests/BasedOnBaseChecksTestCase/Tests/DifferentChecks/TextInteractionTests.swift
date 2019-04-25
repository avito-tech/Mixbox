import MixboxUiTestsFoundation
import XCTest

final class TextInteractionTests: BaseChecksTestCase {
    func test_assert_passes_immediately_ifUiAppearsImmediately() {
        checkAssert_passes_immediately_ifUiAppearsImmediately(passingAssertSpecification())
    }
    
    func test_assert_fails_immediately_ifUiDoesntAppearImmediately() {
        checkAssert_fails_immediately_ifUiDoesntAppearImmediately(passingAssertSpecification())
    }
    
    private func passingAssertSpecification() -> AssertSpecification<LabelElement> {
        return AssertSpecification(
            element: { screen in screen.checkText0 },
            assert: { XCTAssertEqual($0.text(), "Полное соответствие") }
        )
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_text_failsProperlyIfTextMismatches() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "получить значение "text" видимого элемента "isNotDisplayed0"" неуспешно, так как: элемент не найден в иерархии
                """,
            body: {
                _ = screen.isNotDisplayed0.withoutTimeout.text()
            }
        )
    }
}
