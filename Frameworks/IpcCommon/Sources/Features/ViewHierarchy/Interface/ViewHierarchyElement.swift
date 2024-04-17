#if MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON && MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON
#error("IpcCommon is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IPC_COMMON || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IPC_COMMON)
// The compilation is disabled
#else

import UIKit
import MixboxFoundation

public protocol ViewHierarchyElement {
    var frame: OptionalAvailability<CGRect> { get }

    // Note that there is no way to calculate this from fields, because the logic of coordinates conversion
    // is not constant for every view (and is proprietary for many views).
    var frameRelativeToScreen: CGRect { get }
    
    var customClass: String { get }
    var elementType: ViewHierarchyElementType { get }
    var accessibilityIdentifier: String? { get }
    var accessibilityLabel: String? { get }
    var accessibilityValue: String? { get }
    var accessibilityPlaceholderValue: String? { get }
    
    // Text that user will see if the view is visible. Can be calculated from different propeties.
    // For example, it can be `var placeholder` for UITextView if placeholder is displayed, or `var text` otherwise.
    var text: String? { get }
    
    // Unique identifier of the element. Can be used to request info about the element,
    // for example, percentage of visible area of the view, etc.
    var uniqueIdentifier: String { get }
    
    // true: is hidden, can not be visible even after scrolling.
    // false: we don't know
    //
    // It violates SRP. It is used for many purposes:
    // - As an optimization for expensive check for visibility
    // - To filter out collection view cells that are not visible, but used for fade animations. They are hidden most of the time.
    var isDefinitelyHidden: Bool { get }
    
    var isEnabled: Bool { get }
    
    var hasKeyboardFocus: Bool { get }
    
    // Custom values that can be set in the application for testing. Example: you can set coordinates of the map
    // inside a property in the app and validate them in tests.
    // NOTE: Values are serialized. Use `TestabilityCustomValues` to serialize/deserialize.
    var customValues: [String: String] { get }
    
    var children: RandomAccessCollectionOf<ViewHierarchyElement, Int> { get }
}

extension ViewHierarchyElement {
    var debugDescription: String {
        let childrenDescription = children
            .map { $0.debugDescription }
            .joined(separator: ",\n")
            .mb_wrapAndIndent(
                prefix: "{",
                postfix: "}"
            )
        
        var fields = [(key: String, value: String?)]()
        
        let customFields: [(key: String, value: String?)] = customValues.map { (key: String, value: String) in
            (key: "customValue[\(key)]", value: value)
        }
        
        fields.append((key: "axId", value: accessibilityIdentifier))
        fields.append((key: "text", value: text))
        fields.append((key: "class", value: customClass))
        
        fields.append(contentsOf: customFields)
        
        fields.append((key: "axLabel", value: accessibilityLabel))
        fields.append((key: "axValue", value: accessibilityValue))
        fields.append((key: "type", value: elementType.debugDescription))
        fields.append((key: "frameOnScreen", value: frameRelativeToScreen.debugDescription))
        fields.append((key: "frame", value: frame.debugDescription))
        fields.append((key: "axPlaceholderValue", value: accessibilityPlaceholderValue))
        fields.append((key: "isDefinitelyHidden", value: isDefinitelyHidden.description))
        fields.append((key: "isEnabled", value: isEnabled.description))
        fields.append((key: "hasKeyboardFocus", value: hasKeyboardFocus.description))
        fields.append((key: "uniqueIdentifier", value: uniqueIdentifier))
        
        let fieldsWithValues = fields.compactMap { (key: String, value: String?) -> (key: String, value: String)? in
            if let value = value {
                return (key: key, value: value)
            } else {
                return nil
            }
        }
        
        let fieldDescriptions = (fieldsWithValues + [(key: "children", value: childrenDescription)])
            .map { pair in "\(pair.key): \(pair.value)" }
            .joined(separator: ", ")
        
        return fieldDescriptions
    }
}

#endif
