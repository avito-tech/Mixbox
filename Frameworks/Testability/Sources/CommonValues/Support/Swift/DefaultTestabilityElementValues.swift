#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

// Default return values for `TestabilityElement`, can be used in various implementations.
public final class DefaultTestabilityElementValues {
    static var accessibilityIdentifier: String? { nil }
    static var accessibilityLabel: String? { nil }
    static var accessibilityPlaceholderValue: String? { nil }
    static var accessibilityValue: String? { nil }
    static var parent: TestabilityElement? { nil }
    static var children: [TestabilityElement] { [] }
    static var elementType: TestabilityElementType { .other }
    static var frame: CGRect { .null }
    static var frameRelativeToScreen: CGRect { .null }
    static var hasKeyboardFocus: Bool { false }
    static var isDefinitelyHidden: Bool { false }
    static var isEnabled: Bool { false }
    static var text: String? { nil }
}

#endif
