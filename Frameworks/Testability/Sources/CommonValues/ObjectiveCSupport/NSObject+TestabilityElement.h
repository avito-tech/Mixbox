#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

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
- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children;

@end

#endif
