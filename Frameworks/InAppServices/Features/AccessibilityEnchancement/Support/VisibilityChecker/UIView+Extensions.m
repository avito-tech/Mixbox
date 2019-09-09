#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "UIView+Extensions.h"
#import "Defines.h"
#include <objc/runtime.h>
@import MixboxTestability;

@implementation UIView (GREYAdditions)

- (void)grey_restoreOpacity {
    NSNumber *alpha = objc_getAssociatedObject(self, @selector(grey_restoreOpacity));
    if (alpha) {
        self.alpha = [alpha floatValue];
        objc_setAssociatedObject(self, @selector(grey_restoreOpacity), nil, OBJC_ASSOCIATION_ASSIGN);
    }
    [self.superview grey_restoreOpacity];
}

- (void)grey_saveCurrentAlphaAndUpdateWithValue:(float)alpha {
    objc_setAssociatedObject(self,
                             @selector(grey_restoreAlpha),
                             @(self.alpha),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.alpha = alpha;
}

- (void)grey_restoreAlpha {
    id alpha = objc_getAssociatedObject(self, @selector(grey_restoreAlpha));
    self.alpha = [alpha floatValue];
    objc_setAssociatedObject(self, @selector(grey_restoreAlpha), nil, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)grey_isVisible {
    if (CGRectIsEmpty([self accessibilityFrame])) {
        return NO;
    }
    
    UIView *ancestorView = self;
    do {
        // TODO: Use Swift bindings or rewrite everything in Swift.
        if ([ancestorView isKindOfClass:[UICollectionViewCell class]] && [ancestorView performSelector:@selector(mb_isFakeCell)]) {
            if (ancestorView.alpha < kGREYMinimumVisibleAlpha) {
                return NO;
            }
        } else {
            if (ancestorView.alpha < kGREYMinimumVisibleAlpha || ancestorView.frame.size.height == 0 || ancestorView.frame.size.width == 0) {
                return NO;
            }
        }
        ancestorView = ancestorView.superview;
    } while (ancestorView);
    
    return YES;
}

- (void)grey_recursivelyMakeOpaque {
    objc_setAssociatedObject(self,
                             @selector(grey_restoreOpacity),
                             @(self.alpha),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.alpha = 1.0;
    [self.superview grey_recursivelyMakeOpaque];
}

- (void)grey_keepSubviewOnTopAndFrameFixed:(UIView *)view {
    NSValue *frameRect = [NSValue valueWithCGRect:view.frame];
    objc_setAssociatedObject(view,
                             @selector(grey_keepSubviewOnTopAndFrameFixed:),
                             frameRect,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self,
                             @selector(grey_bringAlwaysTopSubviewToFront),
                             view,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self bringSubviewToFront:view];
}

- (void)grey_bringAlwaysTopSubviewToFront {
    UIView *alwaysTopSubview =
    objc_getAssociatedObject(self, @selector(grey_bringAlwaysTopSubviewToFront));
    if (alwaysTopSubview && [self.subviews containsObject:alwaysTopSubview]) {
        [self bringSubviewToFront:alwaysTopSubview];
    }
}

@end

#endif
