#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

#import "UIKBTree+Testability.h"

#import <MixboxInAppServices/MixboxInAppServices-Swift.h>

SWIFT_CLASS("UIKBTreeTestablity")
@interface UIKBTreeTestablity : NSObject

- (instancetype)initWithUnderlyingObject:(UIKBTree *)underlyingObject;

- (CGRect)mb_testability_frameRelativeToScreen;
- (TestabilityElementType)mb_testability_elementType;
- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;
- (nonnull NSDictionary<NSString *, NSString *> *)mb_testability_getSerializedCustomValues;
- (nullable id<TestabilityElement>)mb_testability_parent;

@end

static UIKBTreeTestablity * impl(UIKBTree *underlyingObject) {
    return [[UIKBTreeTestablity alloc] initWithUnderlyingObject:underlyingObject];
}

@implementation UIKBTree (Testability)

- (CGRect)mb_testability_frameRelativeToScreen {
    return [impl(self) mb_testability_frameRelativeToScreen];
}

- (TestabilityElementType)mb_testability_elementType {
    return [impl(self) mb_testability_elementType];
}

- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children {
    return [impl(self) mb_testability_children];
}

- (nonnull NSDictionary<NSString *, NSString *> *)mb_testability_getSerializedCustomValues {
    return [impl(self) mb_testability_getSerializedCustomValues];
}

- (nullable id<TestabilityElement>)mb_testability_parent {
    return [impl(self) mb_testability_parent];
}

@end

#endif
