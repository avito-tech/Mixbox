import MixboxUiTestsFoundation
import XCTest

// Actions should stop tests.
// Checks shouldn't, because it can be useful to have all failures in logs.
final class ContinueAfterFailureTests: BaseChecksTestCase {
    func test_assertIsDisplayed_doesntStopTestIfItFails() {
        let gatherFailuresResult = gatherFailures {
            screen.isNotDisplayed0.withoutTimeout.assertIsDisplayed()
            screen.isNotDisplayed0.withoutTimeout.assertIsDisplayed()
        }
        
        XCTAssertEqual(
            gatherFailuresResult.failures.count,
            2,
            "failures count should be > 1: assertIsDisplayed() should not stop test if it is failed"
        )
    }
    
    func test_tap_stopsTestIfItFails() {
        let gatherFailuresResult = gatherFailures {
            screen.isNotDisplayed0.withoutTimeout.tap()
            screen.isNotDisplayed0.withoutTimeout.tap()
        }
        
        XCTAssertEqual(
            gatherFailuresResult.failures.count,
            1,
            "failures count should be == 1: tap() should stop test if it is failed"
        )
    }
}
