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
                "check that height of "expandingLabel" decreased" failed, because: check failed (checkPositiveHeightDifference, main matcher): expected that height of element decreases, but it increased by 0.0
                """,
            body: {
                screen.expandingLabel.assertBecomesShorterAfter {
                    //  nothing
                }
            }
        )
    }
}
