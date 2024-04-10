#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation
import MixboxTestability
import MixboxIpcCommon

final class DTOViewHierarchyElement: ViewHierarchyElement {
    let frame: CGRect
    let frameRelativeToScreen: CGRect
    let customClass: String
    let elementType: ViewHierarchyElementType
    let accessibilityIdentifier: String?
    let accessibilityLabel: String?
    let accessibilityValue: String?
    let accessibilityPlaceholderValue: String?
    let text: String?
    let uniqueIdentifier: String
    let isDefinitelyHidden: Bool
    let isEnabled: Bool
    let hasKeyboardFocus: Bool
    let customValues: [String: String]
    let children: RandomAccessCollectionOf<ViewHierarchyElement, Int>

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
}

#endif
