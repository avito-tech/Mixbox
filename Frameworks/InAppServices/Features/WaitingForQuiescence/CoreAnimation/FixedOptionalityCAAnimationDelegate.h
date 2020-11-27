#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

@import QuartzCore;

// `CAAnimation` has incorrect optionality. Without optionality, the code crashes.
// If implementation is in swift code and optionality is correct, this warning is displayed:
//
// ```
// Parameter of 'animationDidStart' has different optionality than expected by protocol 'CAAnimationDelegate'
// ```
//
// This wrapper is used to suppress the warning, it is initialized with blocks with nullable `CAAnimation` argument.
// It implements protocol with wrong optionality, but in Objective-C process won't crash if non-optional value
// is casted to optional value (because there is no cast in runtime).
//
@interface FixedOptionalityCAAnimationDelegate: NSObject<CAAnimationDelegate>

- (_Nonnull instancetype)initWithAnimationDidStart:(void(^ _Nonnull )(NSObject * _Nonnull, CAAnimation * _Nullable))animationDidStart
                                  animationDidStop:(void(^ _Nonnull )(NSObject * _Nonnull, CAAnimation * _Nullable, BOOL))animationDidStop;

@end

#endif
