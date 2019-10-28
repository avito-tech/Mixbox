#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ViewHierarchyElement: Codable, CustomDebugStringConvertible {
    public let frame: CGRect
    
    // Note that there is no way to calculate this from fields, because the logic of coordinates conversion
    // is not constant for every view (and is proprietary for many views).
    public let frameRelativeToScreen: CGRect
    
    public let customClass: String
    public let elementType: ViewHierarchyElementType
    public let accessibilityIdentifier: String?
    public let accessibilityLabel: String?
    public let accessibilityValue: String?
    public let accessibilityPlaceholderValue: String?
    
    // Text that user will see if the view is visible. Can be calculated from different propeties.
    // For example, it can be `var placeholder` for UITextView if placeholder is displayed, or `var text` otherwise.
    public let text: String?
    
    // Unique identifier of the element. Can be used to request info about the element,
    // for example, percentage of visible area of the view, etc.
    public let uniqueIdentifier: String
    
    // true: is hidden, can not be visible even after scrolling.
    // false: we don't know
    //
    // It violates SRP. It is used for many purposes:
    // - As an optimization for expensive check for visibility
    // - To filter out collection view cells that are not visible, but used for fade animations. They are hidden most of the time.
    public let isDefinitelyHidden: Bool
    
    public let isEnabled: Bool
    
    public let hasKeyboardFocus: Bool
    
    // Custom values that can be set in the application for testing. Example: you can set coordinates of the map
    // inside a property in the app and validate them in tests.
    public let customValues: [String: String]
    
    public let children: [ViewHierarchyElement]
    
    // MARK: - Init

// sourcery:inline:auto:ViewHierarchyElement.Init
    public init(
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
        children: [ViewHierarchyElement])
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
        self.children = children
    }
// sourcery:end
    
    public var debugDescription: String {
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
