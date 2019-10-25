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
                "проверить, что отображается "duplicated_and_both_are_visible"" неуспешно, так как: найдено несколько элементов по заданным критериям
                """,
            body: {
                screen.duplicated_and_both_are_visible.assertIsDisplayed()
            }
        )
    }
}
