#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class EnhancedAccessibilityLabel: Codable {
    // This is what is set to accessibilityLabel in the app.
    // It is optional, because in the app it is optional (in XCTest it is not optional)
    public let originalAccessibilityLabel: String?
    
    // This property is faulted in XCElementSnapshot since Xcode 11.
    // It is not available in private API of XCElementSnapshot
    public let accessibilityValue: String?
    
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
    
    // Text that user will see if the view is visible. Can be calculated from different propeties.
    // For example, it can be `var placeholder` for UITextView if placeholder is displayed, or `var text` otherwise.
    public let text: String?
    
    // Custom values that can be set in the application for testing. Example: you can set coordinates of the map
    // inside a property in the app and validate them in tests.
    public let customValues: [String: String]
    
    public init(
        originalAccessibilityLabel: String?,
        accessibilityValue: String?,
        uniqueIdentifier: String,
        isDefinitelyHidden: Bool,
        text: String?,
        customValues: [String: String])
    {
        self.originalAccessibilityLabel = originalAccessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.uniqueIdentifier = uniqueIdentifier
        self.isDefinitelyHidden = isDefinitelyHidden
        self.text = text
        self.customValues = customValues
    }
}

extension EnhancedAccessibilityLabel {
    public static func originalAccessibilityLabel(accessibilityLabel: String?) -> String? {
        guard let accessibilityLabel = accessibilityLabel else {
            return nil
        }
        
        // Tiny optimization: detect if `accessibilityLabel` contains JSON.
        if accessibilityLabel.starts(with: "{") {
            return fromAccessibilityLabel(accessibilityLabel)?.originalAccessibilityLabel
        } else {
            return accessibilityLabel
        }
    }
    
    // UITextField puts `accessibilityLabel` inside `accessibilityPlaceholderValue`,
    // so it calls `accessibilityLabel` which is swizzled and contains JSON. We should get `originalAccessibilityLabel`
    // from this JSON and it will contain `accessibilityPlaceholderValue`.
    public static func originalAccessibilityPlaceholderValue(accessibilityPlaceholderValue: String?) -> String? {
        if let accessibilityPlaceholderValue = accessibilityPlaceholderValue {
            return originalAccessibilityLabel(accessibilityLabel: accessibilityPlaceholderValue)
        } else {
            return nil
        }
    }
    
    public static func fromAccessibilityLabel(_ accessibilityLabel: String?) -> EnhancedAccessibilityLabel? {
        let container: EnhancedAccessibilityContainer? = accessibilityLabel
            .flatMap(GenericSerialization.deserialize)
        
        return container?.enhancedAccessibilityLabel
    }
    
    public func toAccessibilityLabel() -> String? {
        let container = EnhancedAccessibilityContainer(
            enhancedAccessibilityLabel: self
        )
        return GenericSerialization.serialize(value: container)
    }
}

// Nesting enhancedAccessibilityLabel in EnhancedAccessibilityContainer is needed to mark a JSON that it is
// EnhancedAccessibilityLabel and not something else that looks like it.
public final class EnhancedAccessibilityContainer: Codable {
    public let enhancedAccessibilityLabel: EnhancedAccessibilityLabel
    
    public init(
        enhancedAccessibilityLabel: EnhancedAccessibilityLabel)
    {
        self.enhancedAccessibilityLabel = enhancedAccessibilityLabel
    }
}

#endif
