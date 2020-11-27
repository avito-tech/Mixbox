#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "FixedOptionalityCAAnimationDelegate.h"

@implementation FixedOptionalityCAAnimationDelegate {
    void(^ _Nonnull _animationDidStart)(NSObject * _Nonnull, CAAnimation * _Nullable);
    void(^ _Nonnull _animationDidStop)(NSObject * _Nonnull, CAAnimation * _Nullable, BOOL);
}

- (_Nonnull instancetype)initWithAnimationDidStart:(void(^ _Nonnull )(NSObject * _Nonnull, CAAnimation * _Nullable))animationDidStart
                                  animationDidStop:(void(^ _Nonnull )(NSObject * _Nonnull, CAAnimation * _Nullable, BOOL))animationDidStop;
{
    if (self = [super init]) {
        _animationDidStart = [animationDidStart copy];
        _animationDidStop = [animationDidStop copy];
    }
    return self;
}

- (void)animationDidStart:(CAAnimation *)animation {
    _animationDidStart(self, animation);
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    _animationDidStop(self, animation, finished);
}

@end

#endif
