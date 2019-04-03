import MixboxUiTestsFoundation
import XCTest

final class ChecksTests: TestCase {
    func test() {
        openScreen(name: "ChecksTestsView")
        
        // A lot of things aren't implemented at the moment.
        // TODO: Uncomment, run tests, comment, write code & unit tests
        
        let screen = pageObjects.checksTests
        
        screen.isNotDisplayed0.withoutTimeout.assertIsNotDisplayed()
        XCTAssertFalse(
            screen.isNotDisplayed0.isDisplayed()
        )
        //
        // screen.isNotDisplayed1.withoutTimeout.assertIsNotDisplayed()
        // XCTAssertFalse(
        //     screen.isNotDisplayed1.isDisplayed()
        // )
        //
        // screen.isDisplayed0.assertIsDisplayed()
        // XCTAssertFalse(
        //     screen.isDisplayed0.withoutTimeout.isNotDisplayed()
        // )
    }
}
