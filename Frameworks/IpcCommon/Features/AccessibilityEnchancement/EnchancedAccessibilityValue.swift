#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class EnhancedAccessibilityValue: Codable {
    // This is what is set to accessibilityValue in the app.
    public let originalAccessibilityValue: String?
    
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
        originalAccessibilityValue: String?,
        uniqueIdentifier: String,
        isDefinitelyHidden: Bool,
        text: String?,
        customValues: [String: String])
    {
        self.originalAccessibilityValue = originalAccessibilityValue
        self.uniqueIdentifier = uniqueIdentifier
        self.isDefinitelyHidden = isDefinitelyHidden
        self.text = text
        self.customValues = customValues
    }
    
    public static func fromAccessibilityValue(_ originalAccessibilityValue: String?) -> EnhancedAccessibilityValue? {
        let container: EnhancedAccessibilityContainer? = originalAccessibilityValue.flatMap(GenericSerialization.deserialize)
        return container?.enhancedAccessibilityValue
    }
    
    public func toAccessibilityValue() -> String? {
        let container = EnhancedAccessibilityContainer(
            enhancedAccessibilityValue: self
        )
        return GenericSerialization.serialize(value: container)
    }
}

// Nesting enhancedAccessibilityValue in EnhancedAccessibilityContainer is needed to mark a JSON that it is
// EnhancedAccessibilityValue and not something else that looks like it.
public final class EnhancedAccessibilityContainer: Codable {
    public let enhancedAccessibilityValue: EnhancedAccessibilityValue
    
    public init(
        enhancedAccessibilityValue: EnhancedAccessibilityValue)
    {
        self.enhancedAccessibilityValue = enhancedAccessibilityValue
    }
}

#endif
