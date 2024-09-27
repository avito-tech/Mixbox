#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit
#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif

extension NSObject: TestabilityElement {
    public func mb_testability_getSerializedCustomValues() -> [String : String] {
        impl().mb_testability_getSerializedCustomValues()
    }
    
    @objc public func mb_testability_frame() -> CGRect {
        impl().mb_testability_frame()
    }
    
    @objc public func mb_testability_frameRelativeToScreen() -> CGRect {
        impl().mb_testability_frameRelativeToScreen()
    }
    
    @objc public func mb_testability_customClass() -> String {
        impl().mb_testability_customClass()
    }
    
    @objc public func mb_testability_elementType() -> TestabilityElementType {
        impl().mb_testability_elementType()
    }
    
    @objc public func mb_testability_accessibilityIdentifier() -> String? {
        impl().mb_testability_accessibilityIdentifier()
    }
    
    @objc public func mb_testability_accessibilityLabel() -> String? {
        impl().mb_testability_accessibilityLabel()
    }
    
    @objc public func mb_testability_accessibilityValue() -> String? {
        impl().mb_testability_accessibilityValue()
    }
    
    @objc public func mb_testability_accessibilityPlaceholderValue() -> String? {
        impl().mb_testability_accessibilityPlaceholderValue()
    }
    
    @objc public func mb_testability_text() -> String? {
        impl().mb_testability_text()
    }
    
    @objc public func mb_testability_uniqueIdentifier() -> String {
        impl().mb_testability_uniqueIdentifier()
    }
    
    @objc public func mb_testability_isDefinitelyHidden() -> Bool {
        impl().mb_testability_isDefinitelyHidden()
    }
    
    @objc public func mb_testability_isEnabled() -> Bool {
        impl().mb_testability_isEnabled()
    }
    
    @objc public func mb_testability_hasKeyboardFocus() -> Bool {
        impl().mb_testability_hasKeyboardFocus()
    }
    
    @objc public func mb_testability_children() -> [TestabilityElement] {
        impl().mb_testability_children()
    }
    
    @objc public func mb_testability_parent() -> TestabilityElement? {
        impl().mb_testability_parent()
    }
    
    func impl() -> NSObjectTestabilityElementSwiftImplementation {
        return NSObjectTestabilityElementSwiftImplementation(nsObject: self)
    }
}



#endif
