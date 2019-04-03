import MixboxUiTestsFoundation

final class AssertBecomesShorterAfterInteractionTests: BaseChecksTestCase {
    func test_assertBecomesShorterAfter_passesProperly() {
        screen.expandButton.withoutTimeout.tap()
        
        screen.expandingLabel.assertBecomesShorterAfter { [weak self] in
            self?.screen.collapseButton.withoutTimeout.tap()
        }
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertBecomesShorterAfter_failsProperlyIfElementIsNotChanged() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что высота "expandingLabel" уменьшилась" неуспешно, так как: проверка неуспешна (checkPositiveHeightDifference, main matcher): ожидалось, что элемент уменьшится в высоту, но он увеличился на 0.0
                """,
            body: {
                screen.expandingLabel.assertBecomesShorterAfter {
                    //  nothing
                }
            }
        )
    }
}
