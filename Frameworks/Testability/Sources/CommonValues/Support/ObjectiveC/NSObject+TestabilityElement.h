#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

@import UIKit;

#import "TestabilityElementType.h"
#import "TestabilityElement.h"

@interface NSObject (Testability)

- (CGRect)mb_testability_frame;
- (CGRect)mb_testability_frameRelativeToScreen;
- (nonnull NSString *)mb_testability_customClass;
- (TestabilityElementType)mb_testability_elementType;
- (nullable NSString *)mb_testability_accessibilityIdentifier;
- (nullable NSString *)mb_testability_accessibilityLabel;
- (nullable NSString *)mb_testability_accessibilityValue;
- (nullable NSString *)mb_testability_accessibilityPlaceholderValue;
- (nullable NSString *)mb_testability_text;
- (nonnull NSString *)mb_testability_uniqueIdentifier;
- (BOOL)mb_testability_isDefinitelyHidden;
- (BOOL)mb_testability_isEnabled;
- (BOOL)mb_testability_hasKeyboardFocus;
- (nullable id<TestabilityElement>)mb_testability_parent;
- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;
- (nonnull NSDictionary<NSString *, NSString *> *)mb_testability_getSerializedCustomValues;

@end

#endif
