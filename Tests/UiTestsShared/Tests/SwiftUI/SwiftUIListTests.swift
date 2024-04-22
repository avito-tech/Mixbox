import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

final class SwiftUIListTests: TestCase {
    override func precondition() {
        super.precondition()

        openScreen(name: "SwiftUIListTestsView")
    }

    private static let elementRange = 1...100

    func test_elementsPresent() {
        for elementIndex in Self.elementRange {
            checkIsPresent(text: "\(elementIndex)")
        }
    }

    private func checkIsPresent(
        text: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let element: LabelElement = pageObjects.screen.element(text) { $0.text == text }
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
