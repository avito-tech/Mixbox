import MixboxUiTestsFoundation

final class AssertBecomesTallerAfterInteractionTests: BaseChecksTestCase {
    func test_assertBecomesTallerAfter_passesProperly() {
        reloadViewAndWaitUntilItIsLoaded()
        
        screen.collapseButton.withoutTimeout.tap()
        
        screen.expandingLabel.assertBecomesTallerAfter { [weak self] in
            self?.screen.expandButton.withoutTimeout.tap()
        }
    }
    
    // TODO: Fix description of check. Failure message is far from perfect.
    func test_assertBecomesTallerAfter_failsProperlyIfElementIsNotChanged() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "проверить, что высота "expandingLabel" увеличилась" неуспешно, так как: проверка неуспешна (checkPositiveHeightDifference, main matcher): ожидалось, что элемент увеличится в высоту, но он уменьшился на 0.0
                """,
            body: {
                screen.expandingLabel.assertBecomesTallerAfter {
                    //  nothing
                }
            }
        )
    }
}
