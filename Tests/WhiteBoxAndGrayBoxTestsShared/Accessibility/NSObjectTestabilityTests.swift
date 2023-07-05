import Foundation
import XCTest
@testable import MixboxTestability
@testable import MixboxInAppServices
import MixboxIpcCommon

final class NSObjectTestabilityTests: BaseTestabilityTestCase {
    private let object = NSObject() as TestabilityElement
    
    func test_mb_testability_frame() {
        XCTAssertEqual(
            object.mb_testability_frame(),
            CGRect.null
        )
    }
    
    func test_mb_testability_frameRelativeToScreen() {
        XCTAssertEqual(
            object.mb_testability_frameRelativeToScreen(),
            CGRect.null
        )
    }
    
    func test_mb_testability_customClass() {
        XCTAssertEqual(
            object.mb_testability_customClass(),
            "NSObject"
        )
        
        class SwiftClass: NSObject {}
        
        XCTAssertEqual(
            (SwiftClass() as TestabilityElement).mb_testability_customClass(),
            "SwiftClass"
        )
    }
    
    func test_mb_testability_elementType() {
        XCTAssertEqual(
            TestabilityElementTypeConverter.covertToViewHierarchyElementType(
                elementType: object.mb_testability_elementType()
            ),
            ViewHierarchyElementType.other
        )
    }
    
    func test_mb_testability_accessibilityIdentifier() {
        XCTAssertEqual(
            object.mb_testability_accessibilityIdentifier(),
            nil
        )
    }
    
    func test_mb_testability_accessibilityLabel() {
        XCTAssertEqual(
            object.mb_testability_accessibilityLabel(),
            nil
        )
    }
    
    func test_mb_testability_accessibilityValue() {
        XCTAssertEqual(
            object.mb_testability_accessibilityValue(),
            nil
        )
    }
    
    // Regardless of the `accessibilityStatus`, the `Valuemb_testability_accessibilityPlaceholderValue` is nil.
    // TODO: If `accessibilityPlaceholder` selector is available (`accessibilityStatus` is .full) check the value.
    func test_mb_testability_accessibilityPlaceholderValue() {
        XCTAssertEqual(
            object.mb_testability_accessibilityPlaceholderValue(),
            nil
        )
    }
    
    func test_mb_testability_text() {
        XCTAssertEqual(
            object.mb_testability_text(),
            nil
        )
    }
    
    func test_mb_testability_uniqueIdentifier() {
        XCTAssertEqual(
            object.mb_testability_uniqueIdentifier(),
            object.mb_testability_uniqueIdentifier()
        )
        
        let otherObject = NSObject() as TestabilityElement
        XCTAssertNotEqual(
            object.mb_testability_uniqueIdentifier(),
            otherObject.mb_testability_uniqueIdentifier()
        )
    }
    
    func test_mb_testability_isDefinitelyHidden() {
        XCTAssertEqual(
            object.mb_testability_isDefinitelyHidden(),
            false
        )
    }
    
    func test_mb_testability_isEnabled() {
        XCTAssertEqual(
            object.mb_testability_isEnabled(),
            false
        )
    }
    
    func test_mb_testability_hasKeyboardFocus() {
        XCTAssertEqual(
            object.mb_testability_hasKeyboardFocus(),
            false
        )
    }
    
    func test_mb_testability_children() {
        XCTAssertEqual(
            object.mb_testability_children().count,
            0
        )
    }
}
