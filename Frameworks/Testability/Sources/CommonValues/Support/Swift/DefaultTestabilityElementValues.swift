#if MIXBOX_ENABLE_FRAMEWORK_TESTABILITY && MIXBOX_DISABLE_FRAMEWORK_TESTABILITY
#error("Testability is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_TESTABILITY || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_TESTABILITY)
// The compilation is disabled
#else

import UIKit

#if SWIFT_PACKAGE
import MixboxTestabilityObjc
#endif

// Default return values for `TestabilityElement`, can be used in various implementations.
public final class DefaultTestabilityElementValues {
    public static var accessibilityIdentifier: String? { nil }
    public static var accessibilityLabel: String? { nil }
    public static var accessibilityPlaceholderValue: String? { nil }
    public static var accessibilityValue: String? { nil }
    public static var parent: TestabilityElement? { nil }
    public static var children: [TestabilityElement] { [] }
    public static var elementType: TestabilityElementType { .other }
    public static var frame: CGRect { .null }
    public static var frameRelativeToScreen: CGRect { .null }
    public static var hasKeyboardFocus: Bool { false }
    public static var isDefinitelyHidden: Bool { false }
    public static var isEnabled: Bool { false }
    public static var text: String? { nil }
}

#endif
