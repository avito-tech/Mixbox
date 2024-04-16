#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import UIKit
import MixboxFoundation

public final class CodableViewHierarchyElement: ViewHierarchyElement, Codable {
    public let frame: OptionalAvailability<CGRect>
    public let frameRelativeToScreen: CGRect
    public let customClass: String
    public let elementType: ViewHierarchyElementType
    public let accessibilityIdentifier: String?
    public let accessibilityLabel: String?
    public let accessibilityValue: String?
    public let accessibilityPlaceholderValue: String?
    public let text: String?
    public let uniqueIdentifier: String
    public let isDefinitelyHidden: Bool
    public let isEnabled: Bool
    public let hasKeyboardFocus: Bool
    public let customValues: [String: String]
    public let codableChildren: [CodableViewHierarchyElement]
    
    // MARK: - Init

    public init(
        frame: OptionalAvailability<CGRect>,
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
        codableChildren: [CodableViewHierarchyElement])
    {
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
        self.codableChildren = codableChildren
    }
    
    public convenience init(viewHierarchyElement: ViewHierarchyElement) {
        self.init(
            frame: viewHierarchyElement.frame,
            frameRelativeToScreen: viewHierarchyElement.frameRelativeToScreen,
            customClass: viewHierarchyElement.customClass,
            elementType: viewHierarchyElement.elementType,
            accessibilityIdentifier: viewHierarchyElement.accessibilityIdentifier,
            accessibilityLabel: viewHierarchyElement.accessibilityLabel,
            accessibilityValue: viewHierarchyElement.accessibilityValue,
            accessibilityPlaceholderValue: viewHierarchyElement.accessibilityPlaceholderValue,
            text: viewHierarchyElement.text,
            uniqueIdentifier: viewHierarchyElement.uniqueIdentifier,
            isDefinitelyHidden: viewHierarchyElement.isDefinitelyHidden,
            isEnabled: viewHierarchyElement.isEnabled,
            hasKeyboardFocus: viewHierarchyElement.hasKeyboardFocus,
            customValues: viewHierarchyElement.customValues,
            codableChildren: viewHierarchyElement.children.map {
                CodableViewHierarchyElement(
                    viewHierarchyElement: $0
                )
            }
        )
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case frame
        case frameRelativeToScreen
        case customClass
        case elementType
        case accessibilityIdentifier
        case accessibilityLabel
        case accessibilityValue
        case accessibilityPlaceholderValue
        case text
        case uniqueIdentifier
        case isDefinitelyHidden
        case isEnabled
        case hasKeyboardFocus
        case customValues
        case codableChildren = "children"
    }
    
    // MARK: - ViewHierarchyElement
    
    public var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> {
        RandomAccessCollectionOf(codableChildren)
    }
}

#endif
