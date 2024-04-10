#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxTestability
import MixboxIpcCommon

final class DTOViewHierarchyElement: ViewHierarchyElement {
    var frame: CGRect
    var frameRelativeToScreen: CGRect
    var customClass: String
    var elementType: ViewHierarchyElementType
    var accessibilityIdentifier: String?
    var accessibilityLabel: String?
    var accessibilityValue: String?
    var accessibilityPlaceholderValue: String?
    var text: String?
    var uniqueIdentifier: String
    var isDefinitelyHidden: Bool
    var isEnabled: Bool
    var hasKeyboardFocus: Bool
    var customValues: [String: String]
    var children: RandomAccessCollectionOf<ViewHierarchyElement, Int>

    init(
        frame: CGRect,
        frameRelativeToScreen: CGRect,
        customClass: String,
        elementType: ViewHierarchyElementType,
        accessibilityIdentifier: String?,
        accessibilityLabel: String?,
        accessibilityValue: String?,
        accessibilityPlaceholderValue: String?,
        text: String?,
        uniqueIdentifier: String,
        isDefinitelyHidden: Bool,
        isEnabled: Bool,
        hasKeyboardFocus: Bool,
        customValues: [String: String],
        children: RandomAccessCollectionOf<ViewHierarchyElement, Int>
    ) {
        self.frame = frame
        self.frameRelativeToScreen = frameRelativeToScreen
        self.customClass = customClass
        self.elementType = elementType
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.accessibilityPlaceholderValue = accessibilityPlaceholderValue
        self.text = text
        self.uniqueIdentifier = uniqueIdentifier
        self.isDefinitelyHidden = isDefinitelyHidden
        self.isEnabled = isEnabled
        self.hasKeyboardFocus = hasKeyboardFocus
        self.customValues = customValues
        self.children = children
    }

    init<T>(_ other: T) where T: ViewHierarchyElement {
        self.frame = other.frame
        self.frameRelativeToScreen = other.frameRelativeToScreen
        self.customClass = other.customClass
        self.elementType = other.elementType
        self.accessibilityIdentifier = other.accessibilityIdentifier
        self.accessibilityLabel = other.accessibilityLabel
        self.accessibilityValue = other.accessibilityValue
        self.accessibilityPlaceholderValue = other.accessibilityPlaceholderValue
        self.text = other.text
        self.uniqueIdentifier = other.uniqueIdentifier
        self.isDefinitelyHidden = other.isDefinitelyHidden
        self.isEnabled = other.isEnabled
        self.hasKeyboardFocus = other.hasKeyboardFocus
        self.customValues = other.customValues
        self.children = other.children
    }
}

#endif
