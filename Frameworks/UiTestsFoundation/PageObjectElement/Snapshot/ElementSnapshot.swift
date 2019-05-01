import MixboxFoundation

public protocol ElementSnapshot: class, CustomDebugStringConvertible {
    // Common (can be retrieved via Apple's Accessibility feature):
    
    var frameOnScreen: CGRect { get }
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
    // TODO: Throw exception with exact description what went wrong?
    public func customValue<T: Codable>(key: String) -> T? {
        guard let customValues = customValues.value else {
            // customValues is unavailable
            return nil
        }
        
        guard let stringValue = customValues[key] else {
            // no value for key
            return nil
        }
        
        guard let typedValue: T = GenericSerialization.deserialize(string: stringValue) else {
            // couldn't convert value to T
            return nil
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
                // Why this is not implemented (now I don't know for sure really, the comment was written by past-me):
                // because tests are written for this behavior. I mean, tests on production app. It is not easy to
                // change the behavior of an existing framework.
                // TODO: Remove this behavior.
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
