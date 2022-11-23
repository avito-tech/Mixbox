#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

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
