#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

@import Foundation;

#import "UIKBTree.h"

#import <MixboxTestability/TestabilityElementType.h>
#import <MixboxTestability/TestabilityElement.h>

// Objective-C file was added to not expose private API in headers.
// If we implement this in Swift, swift interop header (MixboxInAppServices-Swift.h) will declare this category.
// Swift interop header can only use public headers, and don't see conditional compilation flags like MIXBOX_ENABLE_ALL_FRAMEWORKS.
// So in order it to work, we must not use conditional compilation flags, which we don't want. So we made this workaround.
@interface UIKBTree (Testability)

- (CGRect)mb_testability_frameRelativeToScreen;
- (TestabilityElementType)mb_testability_elementType;
- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;
- (nonnull NSDictionary<NSString *, NSString *> *)mb_testability_getSerializedCustomValues;
- (nullable id<TestabilityElement>)mb_testability_parent;

@end

#endif
