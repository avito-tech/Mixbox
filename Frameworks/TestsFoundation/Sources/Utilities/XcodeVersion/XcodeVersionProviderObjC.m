#import "XcodeVersionProviderObjC.h"

@implementation XcodeVersionProviderObjC

+ (NSArray<NSNumber *> *)xcodeVersion {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 120000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120100
    return @[@10, @0, @0];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 120100 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120200
    return @[@10, @1, @0];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 120200 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120300
    return @[@10, @2, @0];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 120300 && __IPHONE_OS_VERSION_MAX_ALLOWED < 120400
    return @[@10, @2, @1];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 120400 && __IPHONE_OS_VERSION_MAX_ALLOWED < 130000
    return @[@10, @3, @0];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 && __IPHONE_OS_VERSION_MAX_ALLOWED < 140000
    return @[@11, @0, @0];
#else
    return nil;
#endif
}

@end



