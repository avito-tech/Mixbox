import MixboxUiTestsFoundation
import MixboxGray
import XCTest
import MixboxInAppServices
import MixboxIpcCommon

final class ElementHierarchyDescriptionProviderTests: TestCase {
    private let elementHierarchyDescriptionProvider = GrayElementHierarchyDescriptionProvider(
        viewHierarchyProvider: FakeViewHierarchyProvider()
    )
    
    func test() {
        openScreen(pageObjects.hierarchyTestsView)
        
        guard let actualDescription = elementHierarchyDescriptionProvider.elementHierarchyDescription() else {
            XCTFail("elementHierarchyDescription should not be nil")
            return
        }
        
        // Note: I gave up aligning multiline literal after copypasting.
        // Note: You can browse the string in a text editor that doesn't wrap columns (to review generated description)
        let expectedDescription =
"""
{
    frame=(12.0, 34.0, 56.0, 78.0), customClass=TouchDrawingWindow, elementType=window, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=false, isEnabled=true, hasKeyboardFocus=false, children={
        frame=(12.0, 34.0, 56.0, 78.0), customClass=HierarchyTestsView, elementType=other, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=false, isEnabled=true, hasKeyboardFocus=false, children={
            frame=(12.0, 34.0, 56.0, 78.0), customClass=UILabel, elementType=staticText, accessibilityIdentifier=label.accessibilityIdentifier, accessibilityLabel=label.accessibilityLabel, accessibilityValue=label.accessibilityValue, text=label.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=false, isEnabled=false, hasKeyboardFocus=false, customValue[label.testability_customValues]={"value":"label.testability_customValues"}, children=[],
            frame=(12.0, 34.0, 56.0, 78.0), customClass=UILabel, elementType=staticText, accessibilityIdentifier=hiddenLabel.accessibilityIdentifier, accessibilityLabel=hiddenLabel.accessibilityLabel, accessibilityValue=hiddenLabel.accessibilityValue, text=hiddenLabel.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=false, customValue[hiddenLabel.testability_customValues]={"value":"hiddenLabel.testability_customValues"}, children=[],
            frame=(12.0, 34.0, 56.0, 78.0), customClass=CustomButton, elementType=button, accessibilityIdentifier=button.accessibilityIdentifier, accessibilityLabel=button.accessibilityLabel, accessibilityValue=button.accessibilityValue, text=button.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=false, isEnabled=false, hasKeyboardFocus=false, customValue[button.testability_customValues]={"value":"button.testability_customValues"}, children={
                frame=(12.0, 34.0, 56.0, 78.0), customClass=UIButtonLabel, elementType=staticText, accessibilityLabel=button.text, text=button.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children=[]
            },
            frame=(12.0, 34.0, 56.0, 78.0), customClass=UIButton, elementType=button, accessibilityIdentifier=hiddenButton.accessibilityIdentifier, accessibilityLabel=hiddenButton.accessibilityLabel, accessibilityValue=hiddenButton.accessibilityValue, text=hiddenButton.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=false, customValue[hiddenButton.testability_customValues]={"value":"hiddenButton.testability_customValues"}, children={
                frame=(12.0, 34.0, 56.0, 78.0), customClass=UIButtonLabel, elementType=staticText, accessibilityLabel=hiddenButton.text, text=hiddenButton.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children=[]
            },
            frame=(12.0, 34.0, 56.0, 78.0), customClass=UITextField, elementType=secureTextField, accessibilityIdentifier=focusedTextField.accessibilityIdentifier, accessibilityLabel=focusedTextField.accessibilityLabel, accessibilityValue=focusedTextField.accessibilityValue, accessibilityPlaceholderValue=focusedTextField.placeholder, text=focusedTextField.placeholder, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[focusedTextField.testability_customValues]={"value":"focusedTextField.testability_customValues"}, children={
                frame=(12.0, 34.0, 56.0, 78.0), customClass=UIFieldEditor, elementType=scrollView, accessibilityValue=, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=false, children={
                    frame=(12.0, 34.0, 56.0, 78.0), customClass=_UITextFieldContentView, elementType=other, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children={
                        frame=(12.0, 34.0, 56.0, 78.0), customClass=UITextSelectionView, elementType=other, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children=[]
                    }
                }
            },
            frame=(12.0, 34.0, 56.0, 78.0), customClass=UITextView, elementType=textView, accessibilityIdentifier=notFocusedTextView.accessibilityIdentifier, accessibilityLabel=notFocusedTextView.accessibilityLabel, accessibilityValue=notFocusedTextView.accessibilityValue, text=notFocusedTextView.text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=false, customValue[notFocusedTextView.testability_customValues]={"value":"notFocusedTextView.testability_customValues"}, children={
                frame=(12.0, 34.0, 56.0, 78.0), customClass=_UITextContainerView, elementType=other, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=false, children=[],
                frame=(12.0, 34.0, 56.0, 78.0), customClass=UIImageView, elementType=image, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children=[],
                frame=(12.0, 34.0, 56.0, 78.0), customClass=UIImageView, elementType=image, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=false, hasKeyboardFocus=false, children=[]
            }
        }
    }
}
"""
        
        // `actualDescription` is placed first here, so you should copypaste first result in logs to update `actualDescription`
        // E.g.: run test, press failure in IDE on the next line, cmd+C, cmd+V
        XCTAssertEqual(
            actualDescription,
            expectedDescription
        )
    }
}

private final class FakeViewHierarchyProvider: ViewHierarchyProvider {
    func viewHierarchy() -> ViewHierarchy {
        let firstWindowOrNil = ViewHierarchyProviderImpl()
            .viewHierarchy()
            .rootElements
            .first
            .flatMap(removingDynamicInfo)
        
        let rootElements: [ViewHierarchyElement]
        
        if let firstWindow = firstWindowOrNil {
            rootElements = [firstWindow]
        } else {
            rootElements = []
        }
        
        return ViewHierarchy(
            rootElements: rootElements
        )
    }
    
    private func removingDynamicInfo(viewHierarchyElement element: ViewHierarchyElement) -> ViewHierarchyElement {
        return ViewHierarchyElement(
            frame: CGRect(x: 12, y: 34, width: 56, height: 78),
            frameRelativeToScreen: CGRect(x: 12, y: 34, width: 56, height: 78),
            customClass: element.customClass,
            elementType: element.elementType,
            accessibilityIdentifier: element.accessibilityIdentifier,
            accessibilityLabel: element.accessibilityLabel,
            accessibilityValue: element.accessibilityValue,
            accessibilityPlaceholderValue: element.accessibilityPlaceholderValue,
            text: element.text,
            uniqueIdentifier: "01234567-89AB-CDEF-0123-456789ABCDEF",
            isDefinitelyHidden: element.isDefinitelyHidden,
            isEnabled: element.isEnabled,
            hasKeyboardFocus: element.hasKeyboardFocus,
            customValues: element.customValues,
            children: element.children.map(removingDynamicInfo)
        )
    }
}
