@import Foundation;
@import UIKit;

typedef struct __IOHIDEvent * IOHIDEventRef;

@interface UIEvent(PrivateApi)
- (IOHIDEventRef) _hidEvent;
@end
