import MixboxUiTestsFoundation

final class AssertBecomesShorterAfterInteractionTests: BaseChecksTestCase {
    func test___assertBecomesShorterAfter___passes_properly() {
        reloadViewAndWaitUntilItIsLoaded()
        
        screen.expandButton.withoutTimeout.tap()
        
        screen.expandingLabel.assertBecomesShorterAfter { [weak self] in
            self?.screen.collapseButton.withoutTimeout.tap()
        }
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertBecomesShorterAfter___fails_properly_if_element_is_not_changed() {
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
