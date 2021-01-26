#import "SBTUITunneledApplication.h"

@interface SBTUITunneledApplication (FastLaunching)

- (instancetype)initWithBundleId:(NSString *)bundleId shouldInstallApplication:(BOOL)shouldInstallApplication;

@end
