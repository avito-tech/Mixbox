#if defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY) && defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY)
#error "Testability is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_TESTABILITY) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_TESTABILITY))
// The compilation is disabled
#else

#import "NSObject+TestabilityElement.h"
#import <objc/runtime.h>

@class NSObjectTestabilityElementSwiftImplementation;

#import <MixboxTestability/MixboxTestability-Swift.h>

@implementation NSObject (Testability)

// MARK: - Fields
 
- (CGRect)mb_testability_frame {
    return [self.impl mb_testability_frame];
}

- (CGRect)mb_testability_frameRelativeToScreen {
    return [self.impl mb_testability_frameRelativeToScreen];
}

- (nonnull NSString *)mb_testability_customClass {
    return [self.impl mb_testability_customClass];
}

- (TestabilityElementType)mb_testability_elementType {
    return [self.impl mb_testability_elementType];
}

- (nullable NSString *)mb_testability_accessibilityIdentifier {
    return [self.impl mb_testability_accessibilityIdentifier];
}

- (nullable NSString *)mb_testability_accessibilityLabel {
    return [self.impl mb_testability_accessibilityLabel];
}

- (nullable NSString *)mb_testability_accessibilityValue {
    return [self.impl mb_testability_accessibilityValue];
}

- (nullable NSString *)mb_testability_accessibilityPlaceholderValue {
    return [self.impl mb_testability_accessibilityPlaceholderValue];
}

- (nullable NSString *)mb_testability_text {
    return [self.impl mb_testability_text];
}

- (nonnull NSString *)mb_testability_uniqueIdentifier {
    return [self.impl mb_testability_uniqueIdentifier];
}

- (BOOL)mb_testability_isDefinitelyHidden {
    return [self.impl mb_testability_isDefinitelyHidden];
}

- (BOOL)mb_testability_isEnabled {
    return [self.impl mb_testability_isEnabled];
}

- (BOOL)mb_testability_hasKeyboardFocus {
    return [self.impl mb_testability_hasKeyboardFocus];
}

- (nonnull NSArray<id<TestabilityElement>> *)mb_testability_children {
    return [self.impl mb_testability_children];
}

- (nullable id<TestabilityElement>)mb_testability_parent {
    return [self.impl mb_testability_parent];
}

- (nonnull NSDictionary<NSString *, NSString *> *)mb_testability_getSerializedCustomValues {
    return [self.impl mb_testability_getSerializedCustomValues];
}

// MARK: - Support

- (NSObjectTestabilityElementSwiftImplementation *)impl {
    return [[NSObjectTestabilityElementSwiftImplementation alloc] initWithNsObject:self];
}

@end

#endif
