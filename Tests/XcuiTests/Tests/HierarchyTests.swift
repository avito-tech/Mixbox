import MixboxUiTestsFoundation
import MixboxIpcCommon
import XCTest

// swiftlint:disable force_unwrapping

final class HierarchyTests: TestCase {
    override func precondition() {
        openScreen(name: "HierarchyTestsView")
    }
    
    func test() {
        let result = testCaseUtils.lazilyInitializedIpcClient.call(
            method: VeiwHierarchyIpcMethod()
        )
        
        guard let data = result.data else { return XCTFail("Did not get view hierarchy") }
        
        let rootElements = data.rootElements
        
        var uniqueIdentifiers = [String]()
        fillIdentifiersFrom(viewHierarchyElements: rootElements, in: &uniqueIdentifiers)
        let elementsCount = countOfElementsIn(viewHierarchyElements: rootElements)
        XCTAssert(uniqueIdentifiers.count == elementsCount)
        XCTAssert(Array(Set(uniqueIdentifiers)).count == elementsCount)
        uniqueIdentifiers.forEach {
            let rangeOfUuidRegexp = $0.range(
                of: "[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}",
                options: .regularExpression,
                range: nil,
                locale: nil
            )
            XCTAssert(rangeOfUuidRegexp?.lowerBound == $0.startIndex)
            XCTAssert(rangeOfUuidRegexp?.upperBound == $0.endIndex)
        }
        
        XCTAssert(rootElements.count == 3)
        
        let rootElement = rootElements[0]
        XCTAssert(rootElement.customClass == "TouchDrawingWindow")
        
        XCTAssert(rootElement.children.count == 1)
        let testsView = rootElement.children[0]
        
        let testViewSubviews = testsView.children
        XCTAssert(testViewSubviews.count == 6)
        
        if let labelIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "label.accessibilityIdentifier" }) {
            let label = testViewSubviews[labelIndex]
            XCTAssert(label.customClass == "UILabel")
            XCTAssert(label.accessibilityValue == "label.accessibilityValue")
            XCTAssert(label.accessibilityLabel == "label.accessibilityLabel")
            XCTAssert(label.visibleText == "label.text")
            XCTAssert(label.isDefinitelyHidden == false)
            XCTAssert(label.isEnabled == false)
            XCTAssert(label.hasKeyboardFocus == false)
            XCTAssert(label.customValues == ["label.testability_customValues": "label.testability_customValues"])
            XCTAssert(label.frame == CGRect(x: 0, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find label")
        }
        
        if let hiddenLabelIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "hiddenLabel.accessibilityIdentifier" }) {
            let hiddenLabel = testViewSubviews[hiddenLabelIndex]
            XCTAssert(hiddenLabel.customClass == "UILabel")
            XCTAssert(hiddenLabel.accessibilityValue == "hiddenLabel.accessibilityValue")
            XCTAssert(hiddenLabel.accessibilityLabel == "hiddenLabel.accessibilityLabel")
            XCTAssert(hiddenLabel.visibleText == "hiddenLabel.text")
            XCTAssert(hiddenLabel.isDefinitelyHidden == true)
            XCTAssert(hiddenLabel.isEnabled == true)
            XCTAssert(hiddenLabel.hasKeyboardFocus == false)
            XCTAssert(hiddenLabel.customValues == ["hiddenLabel.testability_customValues": "hiddenLabel.testability_customValues"])
            XCTAssert(hiddenLabel.elementType == .staticText)
            XCTAssert(hiddenLabel.frame == CGRect(x: 5, y: 5, width: 30, height: 30))
        } else {
            XCTFail("Did not find hiddenLabel")
        }
        
        if let buttonIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "button.accessibilityIdentifier" }) {
            let button = testViewSubviews[buttonIndex]
            XCTAssert(button.customClass == "CustomButton")
            XCTAssert(button.accessibilityValue == "button.accessibilityValue")
            XCTAssert(button.accessibilityLabel == "button.accessibilityLabel")
            XCTAssert(button.visibleText == "button.text")
            XCTAssert(button.isDefinitelyHidden == false)
            XCTAssert(button.isEnabled == false)
            XCTAssert(button.hasKeyboardFocus == false)
            XCTAssert(button.customValues == ["button.testability_customValues": "button.testability_customValues"])
            XCTAssert(button.elementType == .button)
            XCTAssert(button.frame == CGRect(x: -10000, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find button")
        }
        
        if let hiddenButtonIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "hiddenButton.accessibilityIdentifier" }) {
            let hiddenButton = testViewSubviews[hiddenButtonIndex]
            XCTAssert(hiddenButton.customClass == "UIButton")
            XCTAssert(hiddenButton.accessibilityValue == "hiddenButton.accessibilityValue")
            XCTAssert(hiddenButton.accessibilityLabel == "hiddenButton.accessibilityLabel")
            XCTAssert(hiddenButton.visibleText == "hiddenButton.text")
            XCTAssert(hiddenButton.isDefinitelyHidden == true)
            XCTAssert(hiddenButton.isEnabled == true)
            XCTAssert(hiddenButton.hasKeyboardFocus == false)
            XCTAssert(hiddenButton.customValues == ["hiddenButton.testability_customValues": "hiddenButton.testability_customValues"])
            XCTAssert(hiddenButton.elementType == .button)
            XCTAssert(hiddenButton.frame == CGRect(x: 10000, y: 10, width: 100, height: 101))
        } else {
            XCTFail("Did not find hiddenButton")
        }
        
        if let focusedTextFieldIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "focusedTextField.accessibilityIdentifier" }) {
            let focusedTextField = testViewSubviews[focusedTextFieldIndex]
            XCTAssert(focusedTextField.customClass == "UITextField")
            XCTAssert(focusedTextField.accessibilityValue == "focusedTextField.accessibilityValue")
            XCTAssert(focusedTextField.accessibilityLabel == "focusedTextField.accessibilityLabel")
            XCTAssert(focusedTextField.accessibilityPlaceholderValue == "focusedTextField.placeholder")
            XCTAssert(focusedTextField.visibleText == "focusedTextField.placeholder")
            XCTAssert(focusedTextField.isDefinitelyHidden == true)
            XCTAssert(focusedTextField.isEnabled == true)
            XCTAssert(focusedTextField.hasKeyboardFocus == true)
            XCTAssert(focusedTextField.customValues == ["focusedTextField.testability_customValues": "focusedTextField.testability_customValues"])
            XCTAssert(focusedTextField.elementType == .secureTextField)
            XCTAssert(focusedTextField.frame == CGRect(x: 10000, y: 1, width: 100, height: 101))
        } else {
            XCTFail("Did not find focusedTextField")
        }
        
        if let notFocusedTextFieldIndex = testViewSubviews.index(where: { $0.accessibilityIdentifier == "notFocusedTextView.accessibilityIdentifier" }) {
            let notFocusedTextField = testViewSubviews[notFocusedTextFieldIndex]
            XCTAssert(notFocusedTextField.customClass == "UITextView")
            XCTAssert(notFocusedTextField.accessibilityValue == "notFocusedTextView.accessibilityValue")
            XCTAssert(notFocusedTextField.accessibilityLabel == "notFocusedTextView.accessibilityLabel")
            XCTAssert(notFocusedTextField.visibleText == "notFocusedTextView.text")
            XCTAssert(notFocusedTextField.isDefinitelyHidden == true)
            XCTAssert(notFocusedTextField.isEnabled == true)
            XCTAssert(notFocusedTextField.hasKeyboardFocus == false)
            XCTAssert(notFocusedTextField.customValues == ["notFocusedTextView.testability_customValues": "notFocusedTextView.testability_customValues"])
            XCTAssert(notFocusedTextField.elementType == .textView)
            XCTAssert(notFocusedTextField.frame == CGRect(x: 1000, y: 1, width: 100, height: 101))
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
