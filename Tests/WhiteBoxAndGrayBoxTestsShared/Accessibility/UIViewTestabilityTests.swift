import XCTest
import MixboxTestability
import UIKit
import TestsIpc
import MixboxInAppServices

final class UIViewTestabilityTests: BaseTestabilityTestCase {
    private let view = UIView()
    
    func test_mb_testability_frame() {
        assertOverrides(
            object: view,
            selector: "mb_testability_frame"
        )
        
        // Initial value
        
        XCTAssertEqual(
            view.mb_testability_frame(),
            .zero
        )
        
        // Value after change
        
        let frame = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        view.frame = frame
        
        XCTAssertEqual(
            view.mb_testability_frame(),
            frame
        )
    }
    
    func test_mb_testability_frameRelativeToScreen() {
        assertOverrides(
            object: view,
            selector: "mb_testability_frameRelativeToScreen"
        )
        
        // Initial value
        
        XCTAssertEqual(
            view.mb_testability_frameRelativeToScreen(),
            .zero
        )
        
        // Value after change
        
        let window = UIWindow()
        let container = UIView()
        
        container.frame = CGRect(x: 1, y: 2, width: 3, height: 4)
        view.frame = CGRect(x: 1, y: 2, width: 3, height: 4)
        
        window.addSubview(container)
        container.addSubview(view)
        
        XCTAssertEqual(
            view.mb_testability_frameRelativeToScreen(),
            CGRect(x: 2, y: 4, width: 3, height: 4)
        )
    }
    
    func test_mb_testability_customClass() {
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_customClass"
        )
    }
    
    // TODO: More test cases?
    func test_mb_testability_elementType() {
        assertOverrides(
            object: view,
            selector: "mb_testability_elementType"
        )
        
        XCTAssertEqual(
            view.mb_testability_elementType(),
            .other
        )
        
        let label = UILabel()
        
        XCTAssertEqual(
            label.mb_testability_elementType(),
            .staticText
        )
    }
    
    func test_mb_testability_accessibilityIdentifier() {
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_accessibilityIdentifier"
        )
    }
    
    func test_mb_testability_accessibilityLabel() {
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_accessibilityLabel"
        )
    }
    
    func test_mb_testability_accessibilityValue() {
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_accessibilityValue"
        )
    }
    
    func test_mb_testability_accessibilityPlaceholderValue() {
        let view = UITextField()
        
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_accessibilityPlaceholderValue"
        )
        
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            nil
        )
        
        // ---
        
        switch accessibilityStatus {
        case .unknown:
            break
        case .full:
            // This is how UIKit works:
            XCTAssertEqual(
                view.value(forKey: "accessibilityPlaceholderValue") as? String,
                ""
            )
        case .basic:
            // If we try to call `value(forKey: "accessibilityPlaceholderValue")`
            // without initialized accessibility, we get this error:
            //
            // ```
            // NSUnknownKeyException: [<UITextInputTraits 0x7fe4fa90a480> valueForUndefinedKey:]: this class is not key value coding-compliant for the key accessibilityPlaceholderValue."
            // ```
            break
        }
        
        view.placeholder = "text_field_placeholder"
        view.text = "text_field_text"
        
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_accessibilityPlaceholderValue(),
            "text_field_placeholder"
        )
    }
    
    // TODO: More test cases?
    func test_mb_testability_text() {
        assertOverrides(
            object: view,
            selector: "mb_testability_text"
        )
        
        XCTAssertEqual(
            (view as TestabilityElement).mb_testability_text(),
            nil
        )
        
        let label = UILabel()
        label.text = "text"
        
        XCTAssertEqual(
            label.mb_testability_text(),
            "text"
        )
    }
    
    func test_mb_testability_uniqueIdentifier() {
        assertDoesntOverride(
            object: view,
            selector: "mb_testability_uniqueIdentifier"
        )
    }
    
    func test_mb_testability_isDefinitelyHidden() {
        assertOverrides(
            object: view,
            selector: "mb_testability_isDefinitelyHidden"
        )
    }
    
    func test_mb_testability_isEnabled() {
        assertOverrides(
            object: view,
            selector: "mb_testability_isEnabled"
        )
    }
    
    func test_mb_testability_hasKeyboardFocus() {
        assertOverrides(
            object: view,
            selector: "mb_testability_hasKeyboardFocus"
        )
    }
    
    func test_mb_testability_children() {
        assertOverrides(
            object: view,
            selector: "mb_testability_children"
        )
        
        XCTAssert(view.mb_testability_children().isEmpty)
        
        let subview = UIView()
        view.addSubview(subview)
        
        XCTAssert(view.mb_testability_children().mb_only === subview)
    }
    
    // MARK: - Private
    
    private func assertOverrides(object: NSObject, selector: String) {
        assertOverrides(
            object: object,
            selector: Selector.mb_init(privateName: selector)
        )
    }
    
    private func assertDoesntOverride(object: NSObject, selector: String) {
        assertDoesntOverride(
            object: object,
            selector: Selector.mb_init(privateName: selector)
        )
    }
    
    private func assertOverrides(object: NSObject, selector: Selector) {
        assertMethod(
            ofClass: NSObject.self,
            withSelector: selector,
            isOverriden: true,
            inObject: object
        )
    }
    
    private func assertDoesntOverride(object: NSObject, selector: Selector) {
        assertMethod(
            ofClass: NSObject.self,
            withSelector: selector,
            isOverriden: false,
            inObject: object
        )
    }
    
    private func assertMethod(
        ofClass class: NSObject.Type,
        withSelector selector: Selector,
        isOverriden implementationsShouldBeEqual: Bool,
        inObject object: NSObject)
    {
        guard let originalMethod = class_getInstanceMethod(`class`, selector) else {
            XCTFail("Class \(`class`) doesn't have method \(selector)")
            return
        }
        
        let originalImplementation = method_getImplementation(originalMethod)
        
        guard let objectImplementation = object.method(for: selector) else {
            XCTFail("Object \(object) doesn't have method \(selector)")
            return
        }
        
        let implementationsAreEqual = originalImplementation == objectImplementation
        let implementationsShouldBeEqual = originalImplementation == objectImplementation
        
        if implementationsAreEqual != implementationsShouldBeEqual {
            XCTFail(
                "Methods have different implementations"
            )
        }
    }
}
