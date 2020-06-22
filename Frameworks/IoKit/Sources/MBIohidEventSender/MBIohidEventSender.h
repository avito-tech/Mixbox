#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>
#if SWIFT_PACKAGE
#include "../PrivateApi/IOKit/hid/IOHIDEvent.h"
#else
#include "IOHIDEvent.h"
#endif
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// This class is Objective-C, because it uses Soft-Linking.
@interface MBIohidEventSender : NSObject

- (nonnull instancetype)init;

- (nullable NSString *)sendEvent:(nonnull IOHIDEventRef)event
            application:(nonnull UIApplication *)application;

- (void)waitForEventsBeingSentToApplication:(nonnull UIApplication *)application
                            completionBlock:(nonnull void (^)(NSString * __nullable))completionBlock;

- (void)handleIohidEvent:(nonnull IOHIDEventRef)event;

@end

#endif
