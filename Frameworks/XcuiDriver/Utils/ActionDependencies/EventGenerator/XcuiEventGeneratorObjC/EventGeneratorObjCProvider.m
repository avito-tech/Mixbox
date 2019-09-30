#import "EventGeneratorObjCProvider.h"

#import "Xcode_10_1_Xcode_10_0_EventGeneratorObjC.h"
#import "Xcode_10_2_Xcode_11_0_EventGeneratorObjC.h"

@implementation EventGeneratorObjCProvider

+ (nonnull id<EventGeneratorObjC>)eventGeneratorObjC {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 120200
    return [Xcode_10_1_Xcode_10_0_EventGeneratorObjC new];
#else
    return [Xcode_10_2_Xcode_11_0_EventGeneratorObjC new];
#endif
}

@end
