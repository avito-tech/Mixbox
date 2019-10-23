import MixboxUiTestsFoundation
import XCTest

final class AssertingCustomValuesTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(name: "AssertingCustomValuesTestsView")
    }
    
    private static let valueKey = "valueKey"
    
    func test_equals() {
        check(
            customValue: "string",
            equals: "the string"
        )
        check(
            customValue: "bool_false",
            equals: false
        )
        check(
            customValue: "bool_true",
            equals: true
        )
        check(
            customValue: "int_0",
            equals: 0
        )
        check(
            customValue: "int_1",
            equals: 1
        )
        check(
            customValue: "int_-1",
            equals: -1
        )
        check(
            customValue: "double_0",
            equals: Double(0)
        )
        check(
            customValue: "double_inf",
            equals: Double.infinity
        )
    }
    
    func test_isCloseTo() {
        check(id: "double_1.0") {
            $0.customValues[AssertingCustomValuesTests.valueKey].isClose(to: 1.0, delta: 0)
        }
        
        checkFails(id: "double_1.0") {
            $0.customValues[AssertingCustomValuesTests.valueKey].isClose(to: 1.1, delta: 0)
        }
    }
    
    func test_isCloseTo_boundaries() {
        check(id: "double_1.0") {
            $0.customValues[AssertingCustomValuesTests.valueKey].isClose(to: 1.1, delta: 0.100001)
        }
        
        checkFails(id: "double_1.0") {
            $0.customValues[AssertingCustomValuesTests.valueKey].isClose(to: 1.1, delta: 0.099999)
        }
    }
    
    private func check<T: Codable & Equatable>(
        customValue id: String,
        equals value: T)
    {
        check(id: id) {
            $0.customValues[AssertingCustomValuesTests.valueKey] == value
        }
    }
    
    private func checkFails(
        id: String,
        matcher: @escaping ElementMatcherBuilderClosure)
    {
        check(id: id, passes: false, matcher: matcher)
    }
    
    private func check(
        id: String,
        passes: Bool = true,
        matcher: @escaping ElementMatcherBuilderClosure)
    {
        let element: ViewElement = pageObjects.screen.element(id) { $0.id == id }
        
        element.withoutTimeout.assertIsDisplayed()
        
        assert(passes: passes) {
            element.withoutTimeout.assertMatches {
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
