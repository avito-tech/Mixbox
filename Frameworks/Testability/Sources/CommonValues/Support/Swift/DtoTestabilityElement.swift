#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

// "Data Transfer Object", a variation of `TestabilityElement` that can
// be created from fields and doesn't have any behavior.
public final class DtoTestabilityElement: TestabilityElement {
    public let accessibilityIdentifier: String?
    public let accessibilityLabel: String?
    public let accessibilityPlaceholderValue: String?
    public let accessibilityValue: String?
    public let parent: TestabilityElement?
    public let children: [TestabilityElement]
    public let customClass: String
    public let elementType: TestabilityElementType
    public let frame: CGRect
    public let frameRelativeToScreen: CGRect
    public let hasKeyboardFocus: Bool
    public let isDefinitelyHidden: Bool
    public let isEnabled: Bool
    public let text: String?
    public let uniqueIdentifier: String
    
    public init(
        accessibilityIdentifier: String?,
        accessibilityLabel: String?,
        accessibilityPlaceholderValue: String?,
        accessibilityValue: String?,
        parent: TestabilityElement?,
        children: [TestabilityElement],
        customClass: String,
        elementType: TestabilityElementType,
        frame: CGRect,
        frameRelativeToScreen: CGRect,
        hasKeyboardFocus: Bool,
        isDefinitelyHidden: Bool,
        isEnabled: Bool,
        text: String?,
        uniqueIdentifier: String)
    {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityPlaceholderValue = accessibilityPlaceholderValue
        self.accessibilityValue = accessibilityValue
        self.parent = parent
        self.children = children
        self.customClass = customClass
        self.elementType = elementType
        self.frame = frame
        self.frameRelativeToScreen = frameRelativeToScreen
        self.hasKeyboardFocus = hasKeyboardFocus
        self.isDefinitelyHidden = isDefinitelyHidden
        self.isEnabled = isEnabled
        self.text = text
        self.uniqueIdentifier = uniqueIdentifier
    }
    
    public func mb_testability_accessibilityIdentifier() -> String? {
        return accessibilityIdentifier
    }

    public func mb_testability_accessibilityLabel() -> String? {
        return accessibilityLabel
    }

    public func mb_testability_accessibilityPlaceholderValue() -> String? {
        return accessibilityPlaceholderValue
    }

    public func mb_testability_accessibilityValue() -> String? {
        return accessibilityValue
    }

    public func mb_testability_parent() -> TestabilityElement? {
        return parent
    }

    public func mb_testability_children() -> [TestabilityElement] {
        return children
    }

    public func mb_testability_customClass() -> String {
        return customClass
    }

    public func mb_testability_elementType() -> TestabilityElementType {
        return elementType
    }

    public func mb_testability_frame() -> CGRect {
        return frame
    }

    public func mb_testability_frameRelativeToScreen() -> CGRect {
        return frameRelativeToScreen
    }

    public func mb_testability_hasKeyboardFocus() -> Bool {
        return hasKeyboardFocus
    }

    public func mb_testability_isDefinitelyHidden() -> Bool {
        return isDefinitelyHidden
    }

    public func mb_testability_isEnabled() -> Bool {
        return isEnabled
    }

    public func mb_testability_text() -> String? {
        return text
    }

    public func mb_testability_uniqueIdentifier() -> String {
        return uniqueIdentifier
    }
}

#endif
