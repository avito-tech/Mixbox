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
    frame=(12.0, 34.0, 56.0, 78.0), frameRelativeToScreen=(90.0, 12.0, 34.0, 56.0), customClass=UIFooBarView, elementType=staticText, accessibilityIdentifier=identifier, accessibilityLabel=label, accessibilityValue=value, accessibilityPlaceholderValue=placeholderValue, text=text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[A]=B, children={
        frame=(12.0, 34.0, 56.0, 78.0), frameRelativeToScreen=(90.0, 12.0, 34.0, 56.0), customClass=UIFooBarView, elementType=staticText, accessibilityIdentifier=identifier, accessibilityLabel=label, accessibilityValue=value, accessibilityPlaceholderValue=placeholderValue, text=text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[A]=B, children={
            frame=(12.0, 34.0, 56.0, 78.0), frameRelativeToScreen=(90.0, 12.0, 34.0, 56.0), customClass=UIFooBarView, elementType=staticText, accessibilityIdentifier=identifier, accessibilityLabel=label, accessibilityValue=value, accessibilityPlaceholderValue=placeholderValue, text=text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[A]=B, children=[]
        },
        frame=(12.0, 34.0, 56.0, 78.0), frameRelativeToScreen=(90.0, 12.0, 34.0, 56.0), customClass=UIFooBarView, elementType=staticText, accessibilityIdentifier=identifier, accessibilityLabel=label, accessibilityValue=value, accessibilityPlaceholderValue=placeholderValue, text=text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[A]=B, children={
            frame=(12.0, 34.0, 56.0, 78.0), frameRelativeToScreen=(90.0, 12.0, 34.0, 56.0), customClass=UIFooBarView, elementType=staticText, accessibilityIdentifier=identifier, accessibilityLabel=label, accessibilityValue=value, accessibilityPlaceholderValue=placeholderValue, text=text, uniqueIdentifier=01234567-89AB-CDEF-0123-456789ABCDEF, isDefinitelyHidden=true, isEnabled=true, hasKeyboardFocus=true, customValue[A]=B, children=[]
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
        return ViewHierarchy(
            rootElements: [random(children: 2)]
        )
    }
    
    private func random(children: Int) -> ViewHierarchyElement {
        return ViewHierarchyElement(
            frame: CGRect(x: 12, y: 34, width: 56, height: 78),
            frameRelativeToScreen: CGRect(x: 90, y: 12, width: 34, height: 56),
            customClass: "UIFooBarView",
            elementType: .staticText,
            accessibilityIdentifier: "identifier",
            accessibilityLabel: "label",
            accessibilityValue: "value",
            accessibilityPlaceholderValue: "placeholderValue",
            text: "text",
            uniqueIdentifier: "01234567-89AB-CDEF-0123-456789ABCDEF",
            isDefinitelyHidden: true,
            isEnabled: true,
            hasKeyboardFocus: true,
            customValues: ["A": "B"],
            children: children > 0 ? (0..<children).map { _ in random(children: children - 1) } : []
        )
    }
}
