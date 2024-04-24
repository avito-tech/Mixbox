import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

final class SwiftUICustomValuesTests: TestCase {
    private static let valueKey = "value"

    override func precondition() {
        super.precondition()

        openScreen(name: "SwiftUICustomValuesTestsView")
    }

    func test_equals() {
        check(customValue: "string", equals: "value")
        check(customValue: "int", equals: 42)
        check(customValue: "double", equals: 3.14)
        check(customValue: "bool", equals: true)
    }

    private func check<T: Codable & Equatable>(
        customValue id: String,
        equals value: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        check(id: id, file: file, line: line) {
            $0.customValues[Self.valueKey] == value
        }
    }

    private func check(
        id: String,
        passes: Bool = true,
        file: StaticString = #filePath,
        line: UInt = #line,
        matcher: @escaping ElementMatcherBuilderClosure
    ) {
        let element: ViewElement = pageObjects.screen.element(id) { $0.id == id }
        element.withoutTimeout.assertIsDisplayed(file: file, line: line)

        assert(passes: passes, fileOfThisAssertion: file, lineOfThisAssertion: line) {
            element.withoutTimeout.assertMatches(file: file, line: line) {
                matcher($0)
            }
        }
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
