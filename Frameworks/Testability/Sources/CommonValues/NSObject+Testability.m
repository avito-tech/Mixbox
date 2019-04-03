#import "NSObject+Testability.h"

@implementation NSObject (Testability)

- (nonnull NSArray<UIView *> *)testabilityValue_children {
    return [NSArray new];
}

- (BOOL)testabilityValue_hasKeyboardFocus {
    return NO;
}

- (BOOL)testabilityValue_isEnabled {
    return NO;
}

- (nullable NSString *)testabilityValue_text {
    return nil;
}

- (TestabilityElementType)testabilityValue_elementType {
    return TestabilityElementType_Other;
}

@end
