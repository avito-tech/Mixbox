#import "CGGeometry+Extensions.h"
#import "Defines.h"

CGRect CGRectScaleAndTranslate(CGRect inRect, double amount) {
    return CGRectMake((CGFloat)(inRect.origin.x * amount),
                      (CGFloat)(inRect.origin.y * amount),
                      (CGFloat)(inRect.size.width * amount),
                      (CGFloat)(inRect.size.height * amount));
}

CGRect CGRectPointToPixel(CGRect rectInPoints) {
    return CGRectScaleAndTranslate(rectInPoints, [UIScreen mainScreen].scale);
}

CGRect CGRectIntegralInside(CGRect rectInPixels) {
    CGFloat newIntegralX = grey_ceil(CGRectGetMinX(rectInPixels));
    // Adjust horizontal pixel boundary alignment.
    CGFloat newIntegralWidth = CGRectGetMaxX(rectInPixels) - newIntegralX;
    rectInPixels.size.width = newIntegralWidth > 1.0
    ? grey_floor(newIntegralWidth)
    : grey_ceil(rectInPixels.size.width - 0.5);   // rounded up when it's <1 and >0.5 per iOS
    rectInPixels.origin.x = newIntegralX;
    
    // Adjust vertical pixel boundary alignment.
    CGFloat newIntegralY = grey_ceil(CGRectGetMinY(rectInPixels));
    CGFloat newIntegralHeight = CGRectGetMaxY(rectInPixels) - newIntegralY;
    rectInPixels.size.height = newIntegralHeight > 1.0
    ? grey_floor(newIntegralHeight)
    : grey_ceil(rectInPixels.size.height - 0.5);  // rounded up when it's <1 and >=0.5 per iOS
    rectInPixels.origin.y = newIntegralY;
    
    return rectInPixels;
}

double CGRectArea(CGRect rect) {
    return (double)CGRectGetHeight(rect) * (double)CGRectGetWidth(rect);
}

CGRect CGRectIntersectionStrict(CGRect rect1, CGRect rect2) {
    CGRect rect = CGRectIntersection(rect1, rect2);
#if !CGFLOAT_IS_DOUBLE
    // CGRectGetWidth and CGRectGetHeight will return normalized results, this will ensure the
    // resulting rect is no greater than the given sources
    rect.size.width = MIN(CGRectGetWidth(rect),
                          MIN(CGRectGetWidth(rect1), CGRectGetWidth(rect2)));
    rect.size.height = MIN(CGRectGetHeight(rect),
                           MIN(CGRectGetHeight(rect1), CGRectGetHeight(rect2)));
#endif
    return rect;
}

CGRect CGRectPixelToPoint(CGRect rectInPixel) {
    return CGRectScaleAndTranslate(rectInPixel, 1.0 / [UIScreen mainScreen].scale);
}

CGRect CGRectFixedToVariableScreenCoordinates(CGRect rectInFixedCoordinates) {
    UIScreen *screen = [UIScreen mainScreen];
    CGRect rectInVariableCoordinates = CGRectNull;
    if ([screen respondsToSelector:@selector(coordinateSpace)] &&
        [screen respondsToSelector:@selector(fixedCoordinateSpace)]) {
        rectInVariableCoordinates = [screen.fixedCoordinateSpace convertRect:rectInFixedCoordinates
                                                           toCoordinateSpace:screen.coordinateSpace];
    } else { // Pre-iOS 8.
        CGAffineTransform transform =
        CGAffineTransformForFixedToVariable([UIApplication sharedApplication].statusBarOrientation);
        rectInVariableCoordinates = CGRectApplyAffineTransform(rectInFixedCoordinates, transform);
    }
    return rectInVariableCoordinates;
}

CGAffineTransform CGAffineTransformForFixedToVariable(UIInterfaceOrientation orientation) {
    UIScreen *screen = [UIScreen mainScreen];
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        // Rotate pi/2
        transform = CGAffineTransformMake(0, 1, -1, 0, 0, 0);
        transform = CGAffineTransformConcat(transform,
                                            CGAffineTransformTranslate(CGAffineTransformIdentity,
                                                                       CGRectGetHeight(screen.bounds),
                                                                       0));
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        // Rotate -pi/2
        transform = CGAffineTransformMake(0, -1, 1, 0, 0, 0);
        transform = CGAffineTransformConcat(transform,
                                            CGAffineTransformTranslate(CGAffineTransformIdentity,
                                                                       0,
                                                                       CGRectGetWidth(screen.bounds)));
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(screen.bounds),
                                                     -CGRectGetHeight(screen.bounds));
        transform =
        CGAffineTransformConcat(transform,
                                CGAffineTransformScale(CGAffineTransformIdentity, -1.0, -1.0));
    }
    return transform;
}
