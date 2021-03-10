#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

@class SurrogateCAAnimationDelegateSwift;

#import <MixboxInAppServices/MixboxInAppServices-Swift.h>
#import "SurrogateCAAnimationDelegateObjC.h"

@implementation SurrogateCAAnimationDelegateObjC

- (void)animationDidStart:(CAAnimation *)animation {
    [SurrogateCAAnimationDelegateSwift
     animationDidStartWithObject:self
     animation: animation
     isInvokedFromSwizzledMethod: NO];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [SurrogateCAAnimationDelegateSwift
     animationDidStopWithObject:self
     animation: animation
     finished: finished
     isInvokedFromSwizzledMethod: NO];
}

- (void)mbswizzled_animationDidStart:(CAAnimation *)animation {
    [SurrogateCAAnimationDelegateSwift
     animationDidStartWithObject: self
     animation: animation
     isInvokedFromSwizzledMethod: YES];
}

- (void)mbswizzled_animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    [SurrogateCAAnimationDelegateSwift
     animationDidStopWithObject:self
     animation: animation
     finished: finished
     isInvokedFromSwizzledMethod: YES];
}

@end

#endif
