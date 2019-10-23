import MixboxUiTestsFoundation

final class AssertBecomesTallerAfterInteractionTests: BaseChecksTestCase {
    func test___assertBecomesTallerAfter___passes_properly() {
        reloadViewAndWaitUntilItIsLoaded()
        
        screen.collapseButton.withoutTimeout.tap()
        
        screen.expandingLabel.assertBecomesTallerAfter { [weak self] in
            self?.screen.expandButton.withoutTimeout.tap()
        }
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test___assertBecomesTallerAfter___fails_properly_if_element_is_not_changed() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что высота "expandingLabel" увеличилась" неуспешно, так как: проверка неуспешна (checkPositiveHeightDifference, main matcher): ожидалось, что элемент увеличится в высоту, но он уменьшился на 0.0
                """,
            body: {
                screen.expandingLabel.assertBecomesTallerAfter {
                    // nothing
                }
            }
        )
    }
}
