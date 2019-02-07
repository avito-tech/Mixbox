import MixboxUiTestsFoundation
import XCTest

final class ChecksTests: TestCase {
    func test() {
        openScreen(name: "ChecksTestsView")
        
        // A lot of things aren't implemented at the moment.
        // TODO: Uncomment, run tests, comment, write code & unit tests
        
        let screen = pageObjects.checksTests
        
        // screen.label("isNotDisplayed0").withoutTimeout.assert.isNotDisplayed()
        // XCTAssertFalse(
        //     screen.label("isNotDisplayed0").isDisplayed()
        // )
        //
        // screen.label("isNotDisplayed1").withoutTimeout.assert.isNotDisplayed()
        // XCTAssertFalse(
        //     screen.label("isNotDisplayed1").isDisplayed()
        // )
        //
        // screen.label("isDisplayed0").assert.isDisplayed()
        // XCTAssertFalse(
        //     screen.label("isDisplayed0").withoutTimeout.isNotDisplayed()
        // )
    }
}

private final class ChecksTestsScreen: BasePageObjectWithDefaultInitializer {
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button \(id)") { element in element.id == id }
    }
}

private extension PageObjects {
    var checksTests: ChecksTestsScreen {
        return pageObject()
    }
}
