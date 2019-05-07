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
        
        let hardcodedOptionalFields: [(key: String, value: String?)] = [
            (key: "frame", value: frame.debugDescription),
            (key: "frameRelativeToScreen", value: frameRelativeToScreen.debugDescription),
            (key: "customClass", value: customClass),
            (key: "elementType", value: elementType.debugDescription),
            (key: "accessibilityIdentifier", value: accessibilityIdentifier),
            (key: "accessibilityLabel", value: accessibilityLabel),
            (key: "accessibilityValue", value: accessibilityValue),
            (key: "accessibilityPlaceholderValue", value: accessibilityPlaceholderValue),
            (key: "text", value: text),
            (key: "uniqueIdentifier", value: uniqueIdentifier),
            (key: "isDefinitelyHidden", value: isDefinitelyHidden.description),
            (key: "isEnabled", value: isEnabled.description),
            (key: "hasKeyboardFocus", value: hasKeyboardFocus.description)
        ]
        
        let hardcodedFields = hardcodedOptionalFields.compactMap { (key: String, value: String?) -> (key: String, value: String)? in
            if let value = value {
                return (key: key, value: value)
            } else {
                return nil
            }
        }
        
        let customFields = customValues.map { (key: String, value: String) in
            return (key: "customValue[\(key)]", value: value)
        }
        
        let fieldDescriptions = (hardcodedFields + customFields + [(key: "children", value: childrenDescription)])
            .map { pair in "\(pair.key)=\(pair.value)" }
            .joined(separator: ", ")
        
        return fieldDescriptions
    }
}

//private extension Dictionary {
//    func mb_compactMapValues<ElementOfResult>(
//        _ transform: (Element) throws -> ElementOfResult?)
//        rethrows
//        -> [Dictionary<Key, ElementOfResult>]
//    {
//        var result = [Dictionary<Key, ElementOfResult>]()
//        for (key, value) in self {
//            if let transformed = transform(value) {
//                result[key] = transformed
//            }
//        }
//        return result
//    }
//}
