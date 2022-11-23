#if defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES) && defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES)
#error "InAppServices is marked as both enabled and disabled, choose one of the flags"
#elif defined(MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES) || (!defined(MIXBOX_ENABLE_ALL_FRAMEWORKS) && !defined(MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES))
// The compilation is disabled
#else

@import QuartzCore;

// `CAAnimation` has incorrect optionality. Without optionality, the code crashes (note
// that this crash is not covered by tests, it only happens in a prorietary client code).
// If implementation is in swift code and optionality is correct, this warning is displayed:
//
// ```
// Parameter of 'animationDidStart' has different optionality than expected by protocol 'CAAnimationDelegate'
// ```
//
// This wrapper is used to suppress the warning.
// It implements protocol with wrong optionality, but in Objective-C process won't crash if non-optional value
// is casted to optional value (because there is no cast in runtime).
//
// All real logic is in `SurrogateCAAnimationDelegateSwift`.
//
@interface SurrogateCAAnimationDelegateObjC: NSObject<CAAnimationDelegate>

- (void)animationDidStart:(CAAnimation *)animation;
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished;

- (void)mbswizzled_animationDidStart:(CAAnimation *)animation;
- (void)mbswizzled_animationDidStop:(CAAnimation *)animation finished:(BOOL)finished;

@end

#endif
