#import <Foundation/Foundation.h>

typedef struct __IOHIDEvent *IOHIDEventRef;

@interface MBKeyboardEventFactory : NSObject

+ (AbsoluteTime)currentTime;
+ (IOHIDEventRef)eventWithTime:(AbsoluteTime)time usagePage:(uint16_t)usagePage usage:(uint16_t)usage down:(BOOL)down;

@end
