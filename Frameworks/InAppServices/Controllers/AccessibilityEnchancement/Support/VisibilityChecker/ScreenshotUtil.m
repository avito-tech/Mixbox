#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "ScreenshotUtil.h"
#import "Defines.h"
#import "WindowProvider.h"

@implementation ScreenshotUtil

+ (UIImage *)grey_takeScreenshotAfterScreenUpdates:(BOOL)afterScreenUpdates {
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenRect = [self grey_rectRotatedToStatusBarOrientation:mainScreen.bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size, YES, mainScreen.scale);
    [self drawScreenInContext:UIGraphicsGetCurrentContext() afterScreenUpdates:afterScreenUpdates];
    UIImage *orientedScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return orientedScreenshot;
}

#pragma mark - Private

+ (CGRect)grey_rectRotatedToStatusBarOrientation:(CGRect)rect {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!iOS8_0_OR_ABOVE() && UIInterfaceOrientationIsLandscape(orientation)) {
        CGAffineTransform rotationTransform = CGAffineTransformMake(0, 1, 1, 0, 0, 0);
        return CGRectApplyAffineTransform(rect, rotationTransform);
    }
    
    return rect;
}

+ (void)drawScreenInContext:(CGContextRef)bitmapContextRef afterScreenUpdates:(BOOL)afterUpdates {
    NSAssert(CGBitmapContextGetBitmapInfo(bitmapContextRef) != 0,
                               @"The context ref must point to a CGBitmapContext.");
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenRect = [self grey_rectRotatedToStatusBarOrientation:mainScreen.bounds];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // The bitmap context width and height are scaled, so we need to undo the scale adjustment.
    CGFloat contextWidth = CGBitmapContextGetWidth(bitmapContextRef) / mainScreen.scale;
    CGFloat contextHeight = CGBitmapContextGetHeight(bitmapContextRef) / mainScreen.scale;
    CGFloat xOffset = (contextWidth - screenRect.size.width) / 2;
    CGFloat yOffset = (contextHeight - screenRect.size.height) / 2;
    for (UIWindow *window in [[WindowProvider allWindows] reverseObjectEnumerator]) {
        if (window.hidden || window.alpha == 0) {
            continue;
        }
        
        CGContextSaveGState(bitmapContextRef);
        
        CGRect windowRect = window.bounds;
        CGPoint windowCenter = window.center;
        CGPoint windowAnchor = window.layer.anchorPoint;
        
        CGContextTranslateCTM(bitmapContextRef, windowCenter.x + xOffset, windowCenter.y + yOffset);
        CGContextConcatCTM(bitmapContextRef, window.transform);
        CGContextTranslateCTM(bitmapContextRef,
                              -CGRectGetWidth(windowRect) * windowAnchor.x,
                              -CGRectGetHeight(windowRect) * windowAnchor.y);
        if (!iOS8_0_OR_ABOVE()) {
            if (orientation == UIInterfaceOrientationLandscapeLeft) {
                // Rotate pi/2
                CGContextConcatCTM(bitmapContextRef, CGAffineTransformMake(0, 1, -1, 0, 0, 0));
                CGContextTranslateCTM(bitmapContextRef, 0, -CGRectGetWidth(screenRect));
            } else if (orientation == UIInterfaceOrientationLandscapeRight) {
                // Rotate -pi/2
                CGContextConcatCTM(bitmapContextRef, CGAffineTransformMake(0, -1, 1, 0, 0, 0));
                CGContextTranslateCTM(bitmapContextRef, -CGRectGetHeight(screenRect), 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                // Rotate pi
                CGContextConcatCTM(bitmapContextRef, CGAffineTransformMake(-1, 0, 0, -1, 0, 0));
                CGContextTranslateCTM(bitmapContextRef,
                                      -CGRectGetWidth(screenRect),
                                      -CGRectGetHeight(screenRect));
            }
        }
        
        Class gUIAlertControllerShimPresenterWindowClass = NSClassFromString(@"_UIAlertControllerShimPresenterWindow");
        Class gUIModalItemHostingWindowClass = NSClassFromString(@"_UIModalItemHostingWindow");
        
        // This special case is for Alert-Views that for some reason do not render correctly.
        if ([window isKindOfClass:gUIAlertControllerShimPresenterWindowClass] ||
            [window isKindOfClass:gUIModalItemHostingWindowClass]) {
            [window.layer renderInContext:UIGraphicsGetCurrentContext()];
        } else {
            BOOL success = [window drawViewHierarchyInRect:windowRect afterScreenUpdates:afterUpdates];
            if (!success) {
                NSLog(@"Failed to drawViewHierarchyInRect for window: %@", window);
            }
        }
        
        CGContextRestoreGState(bitmapContextRef);
    }
}

@end

#endif
