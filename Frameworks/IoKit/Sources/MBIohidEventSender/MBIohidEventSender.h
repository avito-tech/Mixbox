#if defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT) && defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT)
#error "IoKit is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IO_KIT) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IO_KIT))
// The compilation is disabled
#else

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "IOHIDEvent.h"

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
