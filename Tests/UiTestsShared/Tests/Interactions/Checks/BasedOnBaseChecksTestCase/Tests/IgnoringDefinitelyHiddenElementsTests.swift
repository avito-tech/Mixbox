import MixboxUiTestsFoundation
import XCTest
import MixboxTestsFoundation

final class IgnoringDefinitelyHiddenElementsTests: BaseChecksTestCase {
    func test_assertIsDisplayed_doesntFailWithMultipleMatchesError_ifOneOfDuplicatedViewsIsDefinitelyHidden() {
        reloadViewAndWaitUntilItIsLoaded()
        
        assertPasses {
            screen.duplicated_but_one_is_hidden.assertIsDisplayed()
        }
    }
    
    func test_assertIsDisplayed_failsWithMultipleMatchesError_ifBothDuplicatedOfViewsAreVisible() {
        checkAssertFailsWithDefaultLogs(
            failureMessage: """
                "check that "duplicated_and_both_are_visible" is displayed" failed, because: expected unique element, but found multiple matching elements
                """,
            body: {
                screen.duplicated_and_both_are_visible.assertIsDisplayed()
            }
        )
    }
}
