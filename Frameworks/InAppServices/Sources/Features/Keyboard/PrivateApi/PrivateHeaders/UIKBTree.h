#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

#import "UIKBShape.h"

@interface UIKBTree: NSObject

- (nullable NSArray *)keys; // We did not check if it is non-nullable or nullable. Known to return empty NSArray.
- (nullable NSString *)name; // We did not check if it is non-nullable or nullable.
- (nullable NSString *)displayString; // We did not check if it is non-nullable or nullable.
- (nullable NSString *)representedString; // We did not check if it is non-nullable or nullable.
- (nullable NSString *)localizationKey; // Known to be nullable
- (NSInteger)displayRowHint;

- (CGRect)frame;
- (nullable UIKBShape *)shape; // We did not check if it is non-nullable or nullable.

@end

#endif
