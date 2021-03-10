#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

@import UIKit;

@interface UIApplication (MixboxInAppServices_ApplePrivateAPI)
- (UIWindow *)statusBarWindow;
@end

#endif
