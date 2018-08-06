#import <Foundation/Foundation.h>

static const CGPoint GREYCGPointNull = {NAN, NAN};

CGRect CGRectScaleAndTranslate(CGRect inRect, double amount);

CGRect CGRectPointToPixel(CGRect rectInPoints);

CGRect CGRectIntegralInside(CGRect rectInPixels);

double CGRectArea(CGRect rect);

/**
 *  Return the intersection of @c rect1 and @c rect2. The built-in function can produce floating
 *  errors on 32-bit platform (i.e. iphone 5), which results in a bigger rectangle than both
 *  sources. This will remove the errors by forcing the resulting rectangle to be no greater than
 *  the sources.
 *
 *  @param rect1 The first source rectangle.
 *  @param rect2 The second source rectangle.
 *
 *  @return A rectangle that represents the intersection of the two specified rectangles. If the two
 *          rectangles do not intersect, returns the null rectangle. To check for this condition,
 *          use CGRectIsNull.
 */
CGRect CGRectIntersectionStrict(CGRect rect1, CGRect rect2);

/**
 *  @return The rect obtained by converting the given @c rectInPoints from pixels to points as
 *          per the screen scale.
 */
CGRect CGRectPixelToPoint(CGRect rectInPixel);

/**
 *  Starting with iOS 8.0 window and screen coordinates rotates with the the app's interface
 *  orientation. This method converts the given rect in fixed coordinate space to an oriented rect
 *  matching the current app orientation.
 *
 *  @param rectInFixedCoordinates The rect in fixed coordinates to be transformed to variable
 *                                coordinates.
 *
 *  @return The rect obtained by converting the given @c rectInFixedCoordinates from fixed screen
 *          coordinates to variable screen coordinates.
 */
CGRect CGRectFixedToVariableScreenCoordinates(CGRect rectInFixedCoordinates);

/**
 *  Returns the transform required for transforming from fixed coordinate system (iOS 7 and below)
 *  to variable coordinate system.
 *
 *  @remark This method is only applicable on iOS 7 and below as the later OSes use variable
 *          coordinate system by default.
 *
 *  @param statusBarOrientation A status bar orientation in fixed coordinate system.
 *
 *  @return The transformed status bar orientation for variable coordinate system.
 */
CGAffineTransform CGAffineTransformForFixedToVariable(UIInterfaceOrientation statusBarOrientation);
