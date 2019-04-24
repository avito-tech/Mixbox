import MixboxUiTestsFoundation
import XCTest

final class ChecksTests: BaseChecksTestCase {
    func test() {
        openScreen(name: "ChecksTestsView")
        
        screen.isNotDisplayed1.withoutTimeout.assertIsNotDisplayed()
        assertFails {
            screen.isNotDisplayed1.assertIsDisplayed()
        }
        
        screen.isDisplayed0.assertIsDisplayed()
        assertFails {
            screen.isDisplayed0.withoutTimeout.assertIsNotDisplayed()
        }
    }
}
