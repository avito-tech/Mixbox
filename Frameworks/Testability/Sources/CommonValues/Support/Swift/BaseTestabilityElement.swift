#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

// For subclassing in Swift code. This class takes care of:
// - Defining all function (with default return values).
// - Storing `uniqueIdentifier`.
//
// It is not required to subclass from this class, but it may minimize boilerplate.
//
// NOTE: NSObject already conforms to `TestabilityElement`, there is no need to subclass from
// anything in Objective-C. `uniqueIdentifier` is lazily created and stored in associated object.
//
// NOTE: If you want have mutable properties for "testability" values, consider using `BaseMutableTestabilityElement`.
open class BaseTestabilityElement: TestabilityElement {
    private let uniqueIdentifier: String
    
    public init(uniqueIdentifier: String) {
        self.uniqueIdentifier = uniqueIdentifier
    }
    
    // MARK: - Convenience
    
    public convenience init() {
        self.init(
            uniqueIdentifier: UUID().uuidString
        )
    }
    
    // MARK: - TestabilityElement
    
    open func mb_testability_accessibilityIdentifier() -> String? {
        return DefaultTestabilityElementValues.accessibilityIdentifier
    }
    
    open func mb_testability_accessibilityLabel() -> String? {
        return DefaultTestabilityElementValues.accessibilityLabel
    }
    
    open func mb_testability_accessibilityPlaceholderValue() -> String? {
        return DefaultTestabilityElementValues.accessibilityPlaceholderValue
    }
    
    open func mb_testability_accessibilityValue() -> String? {
        return DefaultTestabilityElementValues.accessibilityValue
    }
    
    open func mb_testability_parent() -> TestabilityElement? {
        return DefaultTestabilityElementValues.parent
    }
    
    open func mb_testability_children() -> [TestabilityElement] {
        return DefaultTestabilityElementValues.children
    }
    
    open func mb_testability_customClass() -> String {
        return String(describing: type(of: self))
    }
    
    open func mb_testability_elementType() -> TestabilityElementType {
        return DefaultTestabilityElementValues.elementType
    }
    
    open func mb_testability_frame() -> CGRect {
        return DefaultTestabilityElementValues.frame
    }
    
    open func mb_testability_frameRelativeToScreen() -> CGRect {
        return DefaultTestabilityElementValues.frameRelativeToScreen
    }
    
    open func mb_testability_hasKeyboardFocus() -> Bool {
        return DefaultTestabilityElementValues.hasKeyboardFocus
    }
    
    open func mb_testability_isDefinitelyHidden() -> Bool {
        return DefaultTestabilityElementValues.isDefinitelyHidden
    }
    
    open func mb_testability_isEnabled() -> Bool {
        return DefaultTestabilityElementValues.isEnabled
    }
    
    open func mb_testability_text() -> String? {
        return DefaultTestabilityElementValues.text
    }
    
    open func mb_testability_uniqueIdentifier() -> String {
        return uniqueIdentifier
    }
}

#endif
