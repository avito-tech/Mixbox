import MixboxFoundation

public protocol ElementSnapshot: class, CustomDebugStringConvertible {
    // Common (can be retrieved via Apple's Accessibility feature):
    
    var frameRelativeToScreen: CGRect { get }
    var elementType: ElementType? { get }
    var hasKeyboardFocus: Bool { get }
    var isEnabled: Bool { get }
    
    var accessibilityIdentifier: String { get }
    var accessibilityLabel: String { get }
    var accessibilityValue: Any? { get }
    var accessibilityPlaceholderValue: String? { get }
    
    var parent: ElementSnapshot? { get }
    var children: [ElementSnapshot] { get }
    
    var uikitClass: String? { get }
    var customClass: String? { get }
    
    // Mixbox specific (for apps with Mixbox support):
    
    var uniqueIdentifier: OptionalAvailability<String> { get }
    var isDefinitelyHidden: OptionalAvailability<Bool> { get }
    var text: OptionalAvailability<String?> { get }
    var customValues: OptionalAvailability<[String: String]> { get }
}

extension ElementSnapshot {
    public func customValue<T: Codable>(key: String) throws -> T {
        guard let customValues = customValues.valueIfAvailable else {
            throw ErrorString(
                """
                `customValues` property is not available for this element. Note that this is expected for third-party \
                apps, because they do not use `MixboxInAppServices` that provides ability to use `customValues`. But it \
                is expected that apps with `MixboxInAppServices` always have `customValues` for all UIView elements.
                """
            )
        }
        
        guard let stringValue = customValues[key] else {
            let customValuesString = "\(customValues)".mb_wrapAndIndent(prefix: "{", postfix: "}")
            throw ErrorString(
                """
                customValues has no value for key "\(key)", all values: \(customValuesString)
                """
            )
        }
        
        guard let typedValue: T = GenericSerialization.deserialize(string: stringValue) else {
            throw ErrorString(
                """
                Couldn't convert custom value for key "\(key)" to type "\(T.self)", \
                value's string representation: "\(stringValue)"
                """
            )
        }
        
        return typedValue
    }
    
    // 1. Returns text (from testabilityValue_text).
    // 2. If this is not possible, `fallback` argument is used, `fallback` can use `label` or `value`.
    //    Different views store text in different accessibility properties.
    //    For example, UITextView/UITextField store text in accessibilityValue.
    //    UILabel store text in accessibilityLabel.
    public func text(fallback: @autoclosure () -> String?) -> String? {
        switch text {
        case .available(let text):
            if let nonNilText = text {
                return nonNilText
            } else {
                // THIS IS WRONG! If we have `.available` text why not to return it event if it is nil?
                // TODO: Change to just `return text` in this switch case.
                //       This will change behavior of matching elements. We need to test new behavior thoroughly.
                return fallback()
            }
        case .unavailable:
            return fallback()
        }
    }
    
    public var debugDescription: String {
        var fields = [String]()
        if let elementType = elementType {
            fields.append("elementType: \(elementType)")
        }
        fields.append("uniqueIdentifier: \(uniqueIdentifier)")
        fields.append("accessibilityIdentifier: \(accessibilityIdentifier)")
        fields.append("accessibilityLabel: \(accessibilityLabel)")
        if let placeholderValue = accessibilityPlaceholderValue {
            fields.append("placeholderValue: \(placeholderValue)")
        }
        if let value = accessibilityValue {
            fields.append("value: \(value)")
        }
        fields.append("isEnabled: \(isEnabled)")
        return fields.joined(separator: "\n")
    }
}
