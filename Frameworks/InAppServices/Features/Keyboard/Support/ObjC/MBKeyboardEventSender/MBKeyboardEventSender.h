#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>

#import "IOHIDEventRef.h"

@interface MBKeyboardEventSender : NSObject

- (nonnull instancetype)init;

- (nullable NSString *)sendEvent:(nonnull IOHIDEventRef)event
            application:(nonnull UIApplication *)application;

- (void)waitForEventsBeingSentToApplication:(nonnull UIApplication *)application
                            completionBlock:(nonnull void (^)(NSString * __nullable))completionBlock;

- (void)handleIohidEvent:(nonnull IOHIDEventRef)event;

@end

#endif
