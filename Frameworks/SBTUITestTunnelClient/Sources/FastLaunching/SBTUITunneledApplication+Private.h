#import "SBTUITunneledApplication.h"

@interface SBTUITunneledApplication (Private)

@property (nonatomic, assign) NSTimeInterval connectionTimeout;

- (BOOL)ping;
- (BOOL)isAppCruising;
- (void)resetInternalState;

@end
