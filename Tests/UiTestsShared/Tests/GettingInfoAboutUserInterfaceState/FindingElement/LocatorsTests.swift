import MixboxUiTestsFoundation
import XCTest

final class LocatorsTests: TestCase {
    func test() {
        openScreen(name: "LocatorsTestsView")
        
        assertExists { $0.id == "label_exists" }
        assertDoesNotExist { $0.id == "label_does_not_exist" }
        
        // Will not produce multiple matches error:
        assertExists { $0.id == "one_of_two_labels_one_is_hidden" }
        
        // Will not produce multiple matches error:
        assertExists {
            $0.id == "one_of_two_labels_one_with_custom_value"
                && $0.customValues["hasCustomValue"] == true
        }
        
        // Custom values
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["string"] == "the string"
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["bool_false"] == false
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["bool_true"] == true
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["int_0"] == 0
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["int_1"] == 1
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["int_-1"] == -1
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["double_0"] == Double(0)
        }
        assertExists {
            $0.id == "one_of_labels_with_custom_values"
                && $0.customValues["double_inf"] == Double.infinity
        }
        
        // TODO:
        //    assertExists {
        //        $0.id == "one_of_labels_with_custom_values"
        //            && $0.customValues["double_nan"] == Double.nan
        //    }
    }
    
    private func assertExists(
        file: StaticString = #file,
        line: UInt = #line,
        matcher: ElementMatcherBuilderClosure)
    {
        let element: ViewElement = pageObjects.screen.element("element") { matcher($0) }
            
        element.withoutTimeout.assertIsInHierarchy(file: file, line: line)
    }
    
    private func assertDoesNotExist(
        file: StaticString = #file,
        line: UInt = #line,
        matcher: ElementMatcherBuilderClosure)
    {
        let element: ViewElement = pageObjects.screen.element("element") { matcher($0) }
        
        // TODO: Ability to easily negate asserts
        assertFails(fileOfThisAssertion: file, lineOfThisAssertion: line) {
            element.withoutTimeout.assertIsInHierarchy(file: file, line: line)
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func wait() {
        let element: ViewElement = self.element("element") { $0.id == "label0" }
        element.assertIsDisplayed()
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
