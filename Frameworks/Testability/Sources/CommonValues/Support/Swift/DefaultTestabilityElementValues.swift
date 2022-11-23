#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

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
