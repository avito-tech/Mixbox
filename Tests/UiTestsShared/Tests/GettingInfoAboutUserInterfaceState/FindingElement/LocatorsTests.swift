import MixboxUiTestsFoundation
import XCTest

final class LocatorsTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.locatorsTestsView).waitUntilViewIsLoaded()
    }
    
    private var screen: LocatorsTestsViewPageObject {
        return pageObjects.locatorsTestsView.default
    }
    
    // MARK: - id
    
    func test___finding_element_by_id___passes___when_element_exists() {
        assertExists { $0.id == "label_that_exists" }
    }

    func test___finding_element_by_id___passes___when_all_elements_with_that_id_are_hidden_expect_for_one() {
        // Will not produce multiple matches error:
        assertExists { $0.id == "one_of_two_labels_one_is_hidden" }
    }
    
    func test___finding_element_by_id___fails___when_element_does_not_exists() {
        assertDoesNotExist { $0.id == "label_that_does_not_exist" }
    }
    
    // MARK: - text
    
    func test___finding_element_by_text___passes___when_element_exists() {
        assertExists { $0.text == "label_that_exists_text" }
    }
    
    // MARK: - label
    
    func test___finding_element_by_label___passes___when_element_exists() {
        assertExists { $0.label == "label_with_accessibilityLabel_accessibilityLabel" }
    }
    
    // MARK: - value
    
    func test___finding_element_by_value___passes___when_element_exists() {
        assertExists { $0.value == "label_with_accessibilityValue_accessibilityValue" }
    }
    
    // MARK: - customValues
    
    func test___finding_element_by_custom_values___passes___when_element_exists() {
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
        let element: ViewElement = screen.element("element") { matcher($0) }
            
        element.withoutTimeout.assertIsInHierarchy(file: file, line: line)
    }
    
    private func assertDoesNotExist(
        file: StaticString = #file,
        line: UInt = #line,
        matcher: ElementMatcherBuilderClosure)
    {
        let element: ViewElement = screen.element("element") { matcher($0) }
        
        // TODO: Ability to easily negate asserts
        assertFails(fileOfThisAssertion: file, lineOfThisAssertion: line) {
            element.withoutTimeout.assertIsInHierarchy(file: file, line: line)
        }
    }
}
