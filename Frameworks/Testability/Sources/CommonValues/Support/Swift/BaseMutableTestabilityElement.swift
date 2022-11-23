#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

// Same as `BaseTestabilityElement`, but it also allows to mutate properties to
// inject return values of functions of `TestabilityElement`.
open class BaseMutableTestabilityElement: TestabilityElement {
    public var accessibilityIdentifier: String?
    public var accessibilityLabel: String?
    public var accessibilityPlaceholderValue: String?
    public var accessibilityValue: String?
    public var parent: TestabilityElement?
    public var children: [TestabilityElement]
    public var customClass: String
    public var elementType: TestabilityElementType
    public var frame: CGRect
    public var frameRelativeToScreen: CGRect
    public var hasKeyboardFocus: Bool
    public var isDefinitelyHidden: Bool
    public var isEnabled: Bool
    public var text: String?
    public var uniqueIdentifier: String
    
    // MARK: - Init
    
    public init() {
        self.accessibilityIdentifier = DefaultTestabilityElementValues.accessibilityIdentifier
        self.accessibilityLabel = DefaultTestabilityElementValues.accessibilityLabel
        self.accessibilityPlaceholderValue = DefaultTestabilityElementValues.accessibilityPlaceholderValue
        self.accessibilityValue = DefaultTestabilityElementValues.accessibilityValue
        self.parent = DefaultTestabilityElementValues.parent
        self.children = DefaultTestabilityElementValues.children
        self.elementType = DefaultTestabilityElementValues.elementType
        self.frame = DefaultTestabilityElementValues.frame
        self.frameRelativeToScreen = DefaultTestabilityElementValues.frameRelativeToScreen
        self.hasKeyboardFocus = DefaultTestabilityElementValues.hasKeyboardFocus
        self.isDefinitelyHidden = DefaultTestabilityElementValues.isDefinitelyHidden
        self.isEnabled = DefaultTestabilityElementValues.isEnabled
        self.text = DefaultTestabilityElementValues.text
        
        self.customClass = String(describing: Self.self)
        self.uniqueIdentifier = UUID().uuidString
    }
    
    // MARK: - Convenience
    
    public func set(frame: CGRect, container: UIView) {
        self.frame = frame
        
        self.frameRelativeToScreen = container.convert(frame, to: nil)
        
        self.parent = container
    }
    
    // MARK: - TestabilityElement
    
    open func mb_testability_accessibilityIdentifier() -> String? {
        return accessibilityIdentifier
    }
    
    open func mb_testability_accessibilityLabel() -> String? {
        return accessibilityLabel
    }
    
    open func mb_testability_accessibilityPlaceholderValue() -> String? {
        return accessibilityPlaceholderValue
    }
    
    open func mb_testability_accessibilityValue() -> String? {
        return accessibilityValue
    }
    
    open func mb_testability_parent() -> TestabilityElement? {
        return parent
    }
    
    open func mb_testability_children() -> [TestabilityElement] {
        return children
    }
    
    open func mb_testability_customClass() -> String {
        return customClass
    }
    
    open func mb_testability_elementType() -> TestabilityElementType {
        return elementType
    }
    
    open func mb_testability_frame() -> CGRect {
        return frame
    }
    
    open func mb_testability_frameRelativeToScreen() -> CGRect {
        return frameRelativeToScreen
    }
    
    open func mb_testability_hasKeyboardFocus() -> Bool {
        return hasKeyboardFocus
    }
    
    open func mb_testability_isDefinitelyHidden() -> Bool {
        return isDefinitelyHidden
    }
    
    open func mb_testability_isEnabled() -> Bool {
        return isEnabled
    }
    
    open func mb_testability_text() -> String? {
        return text
    }
    
    open func mb_testability_uniqueIdentifier() -> String {
        return uniqueIdentifier
    }
}

#endif
