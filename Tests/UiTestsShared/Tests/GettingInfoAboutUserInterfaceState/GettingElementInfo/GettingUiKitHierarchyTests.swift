import MixboxUiTestsFoundation
import MixboxIpcCommon
import XCTest

final class GettingUiKitHierarchyTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.hierarchyTestsView)
    }
    
    // TODO: Fails at getting accessibilityValue and testability_customValues
    // TODO: Fix linter
    // swiftlint:disable:next function_body_length
    func disabled_test() {
        let result = ipcClient.callOrFail(
            method: ViewHierarchyIpcMethod()
        )
        
        let rootElements = result.rootElements
        
        var uniqueIdentifiers = [String]()
        fillIdentifiersFrom(viewHierarchyElements: rootElements, in: &uniqueIdentifiers)
        let elementsCount = countOfElementsIn(viewHierarchyElements: rootElements)
        XCTAssertEqual(uniqueIdentifiers.count, elementsCount)
        XCTAssertEqual(Array(Set(uniqueIdentifiers)).count, elementsCount)
        uniqueIdentifiers.forEach {
            let rangeOfUuidRegexp = $0.range(
                of: "[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}",
                options: .regularExpression,
                range: nil,
                locale: nil
            )
            XCTAssertEqual(rangeOfUuidRegexp?.lowerBound, $0.startIndex)
            XCTAssertEqual(rangeOfUuidRegexp?.upperBound, $0.endIndex)
        }
        
        XCTAssertEqual(rootElements.count, 3)
        
        let rootElement = rootElements[0]
        XCTAssertEqual(rootElement.customClass, "TouchDrawingWindow")
        
        XCTAssertEqual(rootElement.children.count, 1)
        let testsView = rootElement.children[0]
        
        let testViewSubviews = testsView.children
        XCTAssertEqual(testViewSubviews.count, 6)
        
        if let labelIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "label.accessibilityIdentifier" }) {
            let label = testViewSubviews[labelIndex]
            XCTAssertEqual(label.customClass, "UILabel")
            XCTAssertEqual(label.accessibilityValue, "label.accessibilityValue")
            XCTAssertEqual(label.accessibilityLabel, "label.accessibilityLabel")
            XCTAssertEqual(label.text, "label.text")
            XCTAssertEqual(label.isDefinitelyHidden, false)
            XCTAssertEqual(label.isEnabled, false)
            XCTAssertEqual(label.hasKeyboardFocus, false)
            XCTAssertEqual(label.customValues, ["label.testability_customValues": "label.testability_customValues"])
            XCTAssertEqual(label.frame, CGRect(x: 0, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find label")
        }
        
        if let hiddenLabelIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "hiddenLabel.accessibilityIdentifier" }) {
            let hiddenLabel = testViewSubviews[hiddenLabelIndex]
            XCTAssertEqual(hiddenLabel.customClass, "UILabel")
            XCTAssertEqual(hiddenLabel.accessibilityValue, "hiddenLabel.accessibilityValue")
            XCTAssertEqual(hiddenLabel.accessibilityLabel, "hiddenLabel.accessibilityLabel")
            XCTAssertEqual(hiddenLabel.text, "hiddenLabel.text")
            XCTAssertEqual(hiddenLabel.isDefinitelyHidden, true)
            XCTAssertEqual(hiddenLabel.isEnabled, true)
            XCTAssertEqual(hiddenLabel.hasKeyboardFocus, false)
            XCTAssertEqual(hiddenLabel.customValues, ["hiddenLabel.testability_customValues": "hiddenLabel.testability_customValues"])
            XCTAssertEqual(hiddenLabel.elementType, .staticText)
            XCTAssertEqual(hiddenLabel.frame, CGRect(x: 5, y: 5, width: 30, height: 30))
        } else {
            XCTFail("Did not find hiddenLabel")
        }
        
        if let buttonIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "button.accessibilityIdentifier" }) {
            let button = testViewSubviews[buttonIndex]
            XCTAssertEqual(button.customClass, "CustomButton")
            XCTAssertEqual(button.accessibilityValue, "button.accessibilityValue")
            XCTAssertEqual(button.accessibilityLabel, "button.accessibilityLabel")
            XCTAssertEqual(button.text, "button.text")
            XCTAssertEqual(button.isDefinitelyHidden, false)
            XCTAssertEqual(button.isEnabled, false)
            XCTAssertEqual(button.hasKeyboardFocus, false)
            XCTAssertEqual(button.customValues, ["button.testability_customValues": "button.testability_customValues"])
            XCTAssertEqual(button.elementType, .button)
            XCTAssertEqual(button.frame, CGRect(x: -10000, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find button")
        }
        
        if let hiddenButtonIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "hiddenButton.accessibilityIdentifier" }) {
            let hiddenButton = testViewSubviews[hiddenButtonIndex]
            XCTAssertEqual(hiddenButton.customClass, "UIButton")
            XCTAssertEqual(hiddenButton.accessibilityValue, "hiddenButton.accessibilityValue")
            XCTAssertEqual(hiddenButton.accessibilityLabel, "hiddenButton.accessibilityLabel")
            XCTAssertEqual(hiddenButton.text, "hiddenButton.text")
            XCTAssertEqual(hiddenButton.isDefinitelyHidden, true)
            XCTAssertEqual(hiddenButton.isEnabled, true)
            XCTAssertEqual(hiddenButton.hasKeyboardFocus, false)
            XCTAssertEqual(hiddenButton.customValues, ["hiddenButton.testability_customValues": "hiddenButton.testability_customValues"])
            XCTAssertEqual(hiddenButton.elementType, .button)
            XCTAssertEqual(hiddenButton.frame, CGRect(x: 10000, y: 10, width: 100, height: 101))
        } else {
            XCTFail("Did not find hiddenButton")
        }
        
        if let focusedTextFieldIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "focusedTextField.accessibilityIdentifier" }) {
            let focusedTextField = testViewSubviews[focusedTextFieldIndex]
            XCTAssertEqual(focusedTextField.customClass, "UITextField")
            XCTAssertEqual(focusedTextField.accessibilityValue, "focusedTextField.accessibilityValue")
            XCTAssertEqual(focusedTextField.accessibilityLabel, "focusedTextField.accessibilityLabel")
            XCTAssertEqual(focusedTextField.accessibilityPlaceholderValue, "focusedTextField.placeholder")
            XCTAssertEqual(focusedTextField.text, "focusedTextField.placeholder")
            XCTAssertEqual(focusedTextField.isDefinitelyHidden, true)
            XCTAssertEqual(focusedTextField.isEnabled, true)
            XCTAssertEqual(focusedTextField.hasKeyboardFocus, true)
            XCTAssertEqual(focusedTextField.customValues, ["focusedTextField.testability_customValues": "focusedTextField.testability_customValues"])
            XCTAssertEqual(focusedTextField.elementType, .secureTextField)
            XCTAssertEqual(focusedTextField.frame, CGRect(x: 10000, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find focusedTextField")
        }
        
        if let notFocusedTextFieldIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "notFocusedTextView.accessibilityIdentifier" }) {
            let notFocusedTextField = testViewSubviews[notFocusedTextFieldIndex]
            XCTAssertEqual(notFocusedTextField.customClass, "UITextView")
            XCTAssertEqual(notFocusedTextField.accessibilityValue, "notFocusedTextView.accessibilityValue")
            XCTAssertEqual(notFocusedTextField.accessibilityLabel, "notFocusedTextView.accessibilityLabel")
            XCTAssertEqual(notFocusedTextField.text, "notFocusedTextView.text")
            XCTAssertEqual(notFocusedTextField.isDefinitelyHidden, true)
            XCTAssertEqual(notFocusedTextField.isEnabled, true)
            XCTAssertEqual(notFocusedTextField.hasKeyboardFocus, false)
            XCTAssertEqual(notFocusedTextField.customValues, ["notFocusedTextView.testability_customValues": "notFocusedTextView.testability_customValues"])
            XCTAssertEqual(notFocusedTextField.elementType, .textView)
            XCTAssertEqual(notFocusedTextField.frame, CGRect(x: 1000, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find notFocusedTextField")
        }
    }
    
    private func fillIdentifiersFrom(viewHierarchyElements: [ViewHierarchyElement], in result: inout [String]) {
        result.append(
            contentsOf: viewHierarchyElements.map { $0.uniqueIdentifier }
        )
        
        viewHierarchyElements.forEach {
            fillIdentifiersFrom(viewHierarchyElements: $0.children, in: &result)
        }
    }
    
    private func countOfElementsIn(viewHierarchyElements: [ViewHierarchyElement]) -> Int {
        return viewHierarchyElements.count + viewHierarchyElements.reduce(0) {
            $0 + countOfElementsIn(viewHierarchyElements: $1.children)
        }
    }
}
