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
                "check that height of "expandingLabel" increased" failed, because: check failed (checkPositiveHeightDifference, main matcher): expected that height of element increases, but it decreased by 0.0
                """,
            body: {
                screen.expandingLabel.assertBecomesTallerAfter {
                    // nothing
                }
            }
        )
    }
}
