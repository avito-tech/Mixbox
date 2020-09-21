#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit

// Default return values for `TestabilityElement`, can be used in various implementations.
public final class DefaultTestabilityElementValues {
    static let accessibilityIdentifier: String? = nil
    static let accessibilityLabel: String? = nil
    static let accessibilityPlaceholderValue: String? = nil
    static let accessibilityValue: String? = nil
    static let parent: TestabilityElement? = nil
    static let children: [TestabilityElement] = []
    static let elementType: TestabilityElementType = .other
    static let frame: CGRect = .null
    static let frameRelativeToScreen: CGRect = .null
    static let hasKeyboardFocus: Bool = false
    static let isDefinitelyHidden: Bool = false
    static let isEnabled: Bool = false
    static let text: String? = nil
}

#endif
