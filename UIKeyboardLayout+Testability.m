#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

#import "UIKeyboardLayout+Testability.h"

#import <MixboxInAppServices/MixboxInAppServices-Swift.h>

SWIFT_CLASS("UIKeyboardLayoutTestability")
@interface UIKeyboardLayoutTestability : NSObject

- (instancetype)initWithUnderlyingObject:(UIKeyboardLayout *)underlyingObject;

- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;
- (TestabilityElementType)mb_testability_elementType;

@end

static UIKeyboardLayoutTestability * impl(UIKeyboardLayout *underlyingObject) {
    return [[UIKeyboardLayoutTestability alloc] initWithUnderlyingObject:underlyingObject];
}

@implementation UIKeyboardLayout (Testability)

- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children {
    return [impl(self) mb_testability_children];
}

- (TestabilityElementType)mb_testability_elementType {
    return [impl(self) mb_testability_elementType];
}

@end

#endif
