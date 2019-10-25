#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import <Foundation/Foundation.h>
#import "IOHIDEventRef.h"

@interface MBKeyboardEventFactory : NSObject

- (AbsoluteTime)currentTime;
- (IOHIDEventRef)eventWithTime:(AbsoluteTime)time usagePage:(uint16_t)usagePage usage:(uint16_t)usage down:(BOOL)down;

@end

#endif
