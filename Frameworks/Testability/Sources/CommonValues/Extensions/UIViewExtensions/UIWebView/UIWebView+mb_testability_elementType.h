#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

#import "TestabilityElementType.h"

@import UIKit;

// Code was moved from Swift to Objective-C due to a deprecation warning.
// In Swift it is impossible to suppress a single warning, in Objective-C it is possible.
@interface UIWebView (mb_testability_elementType)

- (TestabilityElementType)mb_testability_elementType;

@end

#endif
