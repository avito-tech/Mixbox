#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

@import Foundation;

#import "TestabilityElementType.h"

// Exposes private API
@interface NSObject (AccessibilityPrivateApi)

- (id)accessibilityPlaceholderValue;
- (TestabilityElementType)_accessibilityAutomationType;

@end

#endif
