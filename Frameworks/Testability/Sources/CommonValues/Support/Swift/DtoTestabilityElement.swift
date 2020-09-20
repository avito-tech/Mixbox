#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

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
    
    @objc public func mb_testability_accessibilityIdentifier() -> String? {
        return accessibilityIdentifier
    }

    @objc public func mb_testability_accessibilityLabel() -> String? {
        return accessibilityLabel
    }

    @objc public func mb_testability_accessibilityPlaceholderValue() -> String? {
        return accessibilityPlaceholderValue
    }

    @objc public func mb_testability_accessibilityValue() -> String? {
        return accessibilityValue
    }

    @objc public func mb_testability_parent() -> TestabilityElement? {
        return parent
    }

    @objc public func mb_testability_children() -> [TestabilityElement] {
        return children
    }

    @objc public func mb_testability_customClass() -> String {
        return customClass
    }

    @objc public func mb_testability_elementType() -> TestabilityElementType {
        return elementType
    }

    @objc public func mb_testability_frame() -> CGRect {
        return frame
    }

    @objc public func mb_testability_frameRelativeToScreen() -> CGRect {
        return frameRelativeToScreen
    }

    @objc public func mb_testability_hasKeyboardFocus() -> Bool {
        return hasKeyboardFocus
    }

    @objc public func mb_testability_isDefinitelyHidden() -> Bool {
        return isDefinitelyHidden
    }

    @objc public func mb_testability_isEnabled() -> Bool {
        return isEnabled
    }

    @objc public func mb_testability_text() -> String? {
        return text
    }

    @objc public func mb_testability_uniqueIdentifier() -> String {
        return uniqueIdentifier
    }
}

#endif
