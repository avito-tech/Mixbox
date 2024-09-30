import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

final class SwiftUINavigationBarItemTests: TestCase {
    override func precondition() {
        super.precondition()

        openScreen(name: "SwiftUINavigationBarItemTestsView")
    }

    func test_customItemIsPresent() {
        guard #available(iOS 17.1, *) else {
            return
        }

        let text = "Custom item"
        let element: ButtonElement = pageObjects.screen.element(text) { $0.text == text }
        element.withoutTimeout.assertIsInHierarchy()
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func wait() {
        let element: ViewElement = self.element("string") { $0.id == "label0" }
        element.assertIsDisplayed()
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
