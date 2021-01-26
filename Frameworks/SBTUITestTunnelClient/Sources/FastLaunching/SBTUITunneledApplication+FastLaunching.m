#import "SBTUITunneledApplication+FastLaunching.h"
#import "SBTUITunneledApplication+Private.h"
#import "XCTest-Private.h"

@implementation SBTUITunneledApplication (FastLaunching)

- (instancetype)initWithBundleId:(NSString *)bundleId shouldInstallApplication:(BOOL)shouldInstallApplication {
    if (shouldInstallApplication) {
        self = [super init];
    } else {
        self = [super initPrivateWithPath:nil bundleID:bundleId];
    }
    
    if (self) {
        // As in the original init method:
        [self resetInternalState];
    }
    
    return self;
}

@end
