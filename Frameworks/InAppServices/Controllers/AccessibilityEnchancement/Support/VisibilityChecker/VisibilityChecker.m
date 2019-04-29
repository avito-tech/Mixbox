#ifdef MIXBOX_ENABLE_IN_APP_SERVICES

#import "VisibilityChecker.h"
#import "CGGeometry+Extensions.h"
#import "UIView+Extensions.h"
#import "ScreenshotUtil.h"
#import "Defines.h"

/**
 *  Data structure to hold information about visible pixels.
 */
typedef struct GREYVisiblePixelData {
    /** The number of visible pixels. */
    NSUInteger visiblePixelCount;
    /**
     *  A default pixel that's visible.
     *  If no pixel is visible -- i.e. the visiblePixelCount = 0, then this is set to CGPointNull.
     */
    CGPoint visiblePixel;
} GREYVisiblePixelData;

#pragma mark - GREYVisibilityDiffBuffer

/**
 *  Data structure that holds a buffer representing the visible pixels of a visibility check diff.
 */
typedef struct GREYVisibilityDiffBuffer {
    BOOL *data;
    size_t width;
    size_t height;
} GREYVisibilityDiffBuffer;

/**
 *  Creates a diff buffer with the specified width and height. This method allocates a buffer of
 *  size: width * height, which must be released with GREYVisibilityDiffBufferRelease after being
 *  used.
 *
 *  @param width  The width of the diff buffer.
 *  @param height The height of the diff buffer.
 */
GREYVisibilityDiffBuffer GREYVisibilityDiffBufferCreate(size_t width, size_t height);

/**
 *  Releases the underlying storage for the diff buffer.
 *
 *  @param buffer The buffer whose storage is to be released.
 */
void GREYVisibilityDiffBufferRelease(GREYVisibilityDiffBuffer buffer);

/**
 *  Returns the visibility status for the point at the given x and y coordinates. Returns @c YES if
 *  the point is visible, or @c NO if the point isn't visible or lies outside the buffer's bounds.
 *
 *  @param buffer The buffer that is to be queried.
 *  @param x      The x coordinate of the search point.
 *  @param y      The y coordinate of the search point.
 */
BOOL GREYVisibilityDiffBufferIsVisible(GREYVisibilityDiffBuffer buffer, size_t x, size_t y);

/**
 *  Changes the visibility value for the {@c x, @c y} position. If @c isVisible is @c YES the point
 *  is marked as visible else it is marked as not visible.
 *
 *  @param buffer    The buffer whose visibility is to be updated.
 *  @param x         The x coordinate of the target point.
 *  @param y         The y coordinate of the target point.
 *  @param isVisible A boolean that indicates the new visibility status (@c YES for visible,
 @c NO otherwise) for the target point.
 */
void GREYVisibilityDiffBufferSetVisibility(GREYVisibilityDiffBuffer buffer,
                                           size_t x,
                                           size_t y,
                                           BOOL isVisible);


GREYVisibilityDiffBuffer GREYVisibilityDiffBufferCreate(size_t width, size_t height) {
    GREYVisibilityDiffBuffer diffBuffer;
    diffBuffer.width = width;
    diffBuffer.height = height;
    diffBuffer.data = (BOOL *)malloc(sizeof(BOOL) * width * height);
    if (diffBuffer.data == NULL) {
        NSLog(@"diffBuffer.data is NULL.");
        abort();
    }
    return diffBuffer;
}

void GREYVisibilityDiffBufferRelease(GREYVisibilityDiffBuffer buffer) {
    if (buffer.data == NULL) {
        NSLog(@"buffer.data is NULL.");
        abort();
    }
    free(buffer.data);
}

BOOL GREYVisibilityDiffBufferIsVisible(GREYVisibilityDiffBuffer buffer, size_t x, size_t y) {
    if (x >= buffer.width || y >= buffer.height) {
        return NO;
    }
    
    return buffer.data[y * buffer.width + x];
}

inline void GREYVisibilityDiffBufferSetVisibility(GREYVisibilityDiffBuffer buffer,
                                                  size_t x,
                                                  size_t y,
                                                  BOOL value) {
    if (x >= buffer.width || y >= buffer.height) {
        NSLog(@"Warning: trying to access a point outside the diff buffer: {%zu, %zu}", x, y);
        return;
    }
    
    buffer.data[y * buffer.width + x] = value;
}

unsigned char *grey_createImagePixelDataFromCGImageRef(CGImageRef imageRef,
                                                       CGContextRef *outBmpCtx);

@implementation VisibilityChecker

+ (double)percentElementVisibleOnScreen:(UIView *)view {
    return [self grey_percentViewVisibleOnScreen:view withinRect:[view accessibilityFrame]];
}

+ (double)grey_percentViewVisibleOnScreen:(UIView *)view
                          withinRect:(CGRect)searchRectInScreenCoordinates
{
    CGImageRef beforeImage = NULL;
    CGImageRef afterImage = NULL;
    BOOL viewIntersectsScreen = [self grey_captureBeforeImage:&beforeImage
                                           andAfterImage:&afterImage
                                andGetIntersectionOrigin:NULL
                                                 forView:view
                                              withinRect:searchRectInScreenCoordinates];
    
    double percentVisible = 0;
    if (viewIntersectsScreen) {
        // Count number of whole pixels in entire search area, including areas off screen or outside
        // view.
        CGRect searchRect_pixels = CGRectPointToPixel(searchRectInScreenCoordinates);
        double countTotalSearchRectPixels = CGRectArea(CGRectIntegralInside(searchRect_pixels));
        
        GREYVisiblePixelData visiblePixelData = [self grey_countPixelsInImage:afterImage
                                                  thatAreShiftedPixelsOfImage:beforeImage
                                                  storeVisiblePixelRectInRect:NULL
                                             andStoreComparisonResultInBuffer:NULL];
        percentVisible = visiblePixelData.visiblePixelCount / countTotalSearchRectPixels;
    }
    
    CGImageRelease(beforeImage);
    CGImageRelease(afterImage);
    
    NSAssert(0 <= percentVisible,
             @"percentVisible should not be negative. Current Percent: %0.1f%%",
             (double)(percentVisible * 100.0));
    
    return percentVisible;
}

/**
 *  Captures the visibility check's before and after image for the given @c view and loads the pixel
 *  data into the given @c beforeImage and @c afterImage and returns @c YES if at least one pixel
 *  from the view intersects with the given @c searchRectInScreenCoordinates, @c NO otherwise.
 *  Optionally the method also stores the intersection point of the screen, view and search rect
 *  (in pixels) at @c outIntersectionOriginOrNull. The caller must release @c beforeImage and
 *  @c afterImage using CGImageRelease once done using them.
 *
 *  @param[out] outBeforeImage                A reference to receive the before-check image.
 *  @param[out] outAfterImage                 A reference to receive the after-check image.
 *  @param[out] outIntersectionOriginOrNull   A reference to receive the origin of the view in
 *                                            the given search rect.
 *  @param      view                          The view whose visibility check is being performed.
 *  @param      searchRectInScreenCoordinates A rect in screen coordinates within which the
 *                                            visibility check is to be performed.
 *
 *  @return @c YES if at least one pixel from the view intersects with the given
 *          @c searchRectInScreenCoordinates, @c NO otherwise.
 */
+ (BOOL)grey_captureBeforeImage:(CGImageRef *)outBeforeImage
                  andAfterImage:(CGImageRef *)outAfterImage
       andGetIntersectionOrigin:(CGPoint *)outIntersectionOriginOrNull
                        forView:(UIView *)view
                     withinRect:(CGRect)searchRectInScreenCoordinates {
    NSAssert(outBeforeImage, @"outBeforeImage should not be nil");
    NSAssert(outAfterImage, @"outAfterImage should not be nil");
    
    // A quick visibility check is done here to rule out any definitely hidden views.
    if (![view grey_isVisible] || CGRectIsEmpty(searchRectInScreenCoordinates)) {
        return NO;
    }
    
    // Find portion of search rect that is on screen and in view.
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect axFrame = [view accessibilityFrame];
    CGRect searchRectOnScreenInViewInScreenCoordinates =
    CGRectIntersectionStrict(searchRectInScreenCoordinates,
                             CGRectIntersectionStrict(axFrame, screenBounds));
    if (CGRectIsEmpty(searchRectOnScreenInViewInScreenCoordinates)) {
        return NO;
    }
    
    // Calculate the search rectangle for screenshot.
    CGRect screenshotSearchRect_pixel =
    iOS8_0_OR_ABOVE() ? searchRectOnScreenInViewInScreenCoordinates
    : CGRectFixedToVariableScreenCoordinates(searchRectOnScreenInViewInScreenCoordinates);
    screenshotSearchRect_pixel = CGRectPointToPixel(screenshotSearchRect_pixel);
    screenshotSearchRect_pixel = CGRectIntegralInside(screenshotSearchRect_pixel);
    
    // Set screenshot origin point.
    if (outIntersectionOriginOrNull) {
        *outIntersectionOriginOrNull = screenshotSearchRect_pixel.origin;
    }
    
    if (screenshotSearchRect_pixel.size.width == 0 || screenshotSearchRect_pixel.size.height == 0) {
        return NO;
    }
    
    // Take an image of what the view looks like before shifting pixel intensity.
    // Ensures that any implicit animations that might have taken place since the last runloop
    // run are committed to the presentation layer.
    // @see
    // http://optshiftk.com/2013/11/better-documentation-for-catransaction-flush/
    [CATransaction begin];
    [CATransaction flush];
    [CATransaction commit];
    UIImage *beforeScreenshot = [ScreenshotUtil grey_takeScreenshotAfterScreenUpdates:YES];
    CGImageRef beforeImage =
    CGImageCreateWithImageInRect(beforeScreenshot.CGImage, screenshotSearchRect_pixel);
    if (!beforeImage) {
        return NO;
    }
    
    // View with shifted colors will be added on top of all the subviews of view. We offset the view
    // to make it appear in the correct location. If we are checking for visibility of a scroll view,
    // visibility checker will take a picture of the entire UIScrollView, and adjust the frame of
    // shiftedBeforeImageView to position it correctly within the UIScrollView.
    // In iOS 7, UIScrollViews are often full-screen, and a part of them is hidden behind the
    // navigation bar. ContentInsets are set automatically to make this happen seamlessly. In this
    // case, EarlGrey will take a picture of the entire UIScrollView, including the navigation bar,
    // to check visibility, but because navigation bar covers only a small portion of the scroll view,
    // it will still be above the visibility threshold.
    
    // Calculate the search rectangle in view coordinates.
    CGRect searchRectOnScreenInViewInWindowCoordinates =
    [view.window convertRect:searchRectOnScreenInViewInScreenCoordinates fromWindow:nil];
    CGRect searchRectOnScreenInViewInViewCoordinates =
    [view convertRect:searchRectOnScreenInViewInWindowCoordinates fromView:nil];
    
    CGRect rectAfterPixelAlignment = CGRectPixelToPoint(screenshotSearchRect_pixel);
    // Offset must be in variable screen coordinates.
    CGRect searchRectOnScreenInViewInVariableScreenCoordinates = iOS8_0_OR_ABOVE()
    ? searchRectOnScreenInViewInScreenCoordinates
    : CGRectFixedToVariableScreenCoordinates(searchRectOnScreenInViewInScreenCoordinates);
    CGFloat xPixelAlignmentDiff = CGRectGetMinX(rectAfterPixelAlignment) -
    CGRectGetMinX(searchRectOnScreenInViewInVariableScreenCoordinates);
    CGFloat yPixelAlignmentDiff = CGRectGetMinY(rectAfterPixelAlignment) -
    CGRectGetMinY(searchRectOnScreenInViewInVariableScreenCoordinates);
    
    CGFloat searchRectOffsetX =
    CGRectGetMinX(searchRectOnScreenInViewInViewCoordinates) + xPixelAlignmentDiff;
    CGFloat searchRectOffsetY =
    CGRectGetMinY(searchRectOnScreenInViewInViewCoordinates) + yPixelAlignmentDiff;
    
    CGPoint searchRectOffset = CGPointMake(searchRectOffsetX, searchRectOffsetY);
    UIView *shiftedView =
    [self grey_imageViewWithShiftedColorOfImage:beforeImage
                                    frameOffset:searchRectOffset
                                    orientation:beforeScreenshot.imageOrientation];
    UIImage *afterScreenshot = [self grey_imageAfterAddingSubview:shiftedView toView:view];
    CGImageRef afterImage =
    CGImageCreateWithImageInRect(afterScreenshot.CGImage, screenshotSearchRect_pixel);
    if (!afterImage) {
        NSAssert(NO, @"afterImage should not be null");
        CGImageRelease(beforeImage);
        return NO;
    }
    *outBeforeImage = beforeImage;
    *outAfterImage = afterImage;
    
    return YES;
}

+ (UIImage *)grey_imageAfterAddingSubview:(UIView *)shiftedView toView:(UIView *)view {
    NSAssert(shiftedView, @"shiftedView should not be nil");
    NSAssert(view, @"view should not be nil");
    
    UIImage *screenshot = [self grey_prepareView:view forVisibilityCheckAndPerformBlock:^id {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [view addSubview:shiftedView];
        [view grey_keepSubviewOnTopAndFrameFixed:shiftedView];
        [CATransaction flush];
        [CATransaction commit];
        
        UIImage *shiftedImage = [ScreenshotUtil grey_takeScreenshotAfterScreenUpdates:YES];
        [shiftedView removeFromSuperview];
        return shiftedImage;
    }];
    return screenshot;
}

/**
 *  Prepares @c view for visibility check by modifying visual aspects that interfere with
 *  pixel intensities. Then, executes block, restores view's properties and returns the result of
 *  executing the block to the caller.
 */
+ (id)grey_prepareView:(UIView *)view forVisibilityCheckAndPerformBlock:(id (^)(void))block {
    BOOL disablingActions = [CATransaction disableActions];
    BOOL isRasterizingLayer = view.layer.shouldRasterize;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // Rasterizing causes flakiness by re-drawing the view frame by frame for any layout change and
    // caching it for further use. This brings a delay in refreshing the layout for the shiftedView.
    view.layer.shouldRasterize = NO;
    
    // Views may be translucent and there have their alpha adjusted to 1.0 when taking the screenshot
    // because the shifted view, being a child of the view, will inherit its opacity. The problem
    // with that is that shifted view is created from a screenshot of the view with its original
    // opacity, so if we just add the shifted view as a subview of view the opacity change will be
    // applied once more. This may result on false negatives, specially on anti-aliased text. To make
    // sure the opacity won't affect the screenshot, we need to apply the change to the view and all
    // of its parents, then reset the changes when done.
    [view grey_recursivelyMakeOpaque];
    [CATransaction flush];
    [CATransaction commit];
    
    id retVal = block();
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    // Restore opacity back to what it was before.
    [view grey_restoreOpacity];
    view.layer.shouldRasterize = isRasterizingLayer;
    [CATransaction setDisableActions:disablingActions];
    [CATransaction flush];
    [CATransaction commit];
    return retVal;
}

/**
 *  Calculates the number of pixel in @c afterImage that have different pixel intensity in
 *  @c beforeImage.
 *  If @c visiblePixelRect is not NULL, stores the smallest rectangle enclosing all shifted pixels
 *  in @c visiblePixelRect. If no shifted pixels are found, @c visiblePixelRect will be CGRectZero.
 *  @todo Use a better image comparison library/tool for this stuff. For now, pixel-by-pixel
 *        comparison it is.
 *
 *  @param      afterImage          The image containing view with shifted colors.
 *  @param      beforeImage         The original image of the view.
 *  @param[out] outVisiblePixelRect A reference for getting the largest
 *                                  rectangle enclosing only visible points in the view.
 *  @param[out] outDiffBufferOrNULL A reference for getting the GREYVisibilityDiffBuffer that was
 *                                  created to detect image diff.
 *
 *  @return The number of pixels and a default pixel in @c afterImage that are shifted
 *          intensity of @c beforeImage.
 */
+ (GREYVisiblePixelData)grey_countPixelsInImage:(CGImageRef)afterImage
                    thatAreShiftedPixelsOfImage:(CGImageRef)beforeImage
                    storeVisiblePixelRectInRect:(CGRect *)outVisiblePixelRect
               andStoreComparisonResultInBuffer:(GREYVisibilityDiffBuffer *)outDiffBufferOrNULL
{
    NSAssert(beforeImage, @"beforeImage should not be nil");
    NSAssert(afterImage, @"afterImage should not be nil");
    
    NSAssert(CGImageGetWidth(beforeImage) == CGImageGetWidth(afterImage),
                               @"width must be the same");
    NSAssert(CGImageGetHeight(beforeImage) == CGImageGetHeight(afterImage),
                               @"height must be the same");
    unsigned char *pixelBuffer = grey_createImagePixelDataFromCGImageRef(beforeImage, NULL);
    NSAssert(pixelBuffer, @"pixelBuffer must not be null");
    unsigned char *shiftedPixelBuffer = grey_createImagePixelDataFromCGImageRef(afterImage, NULL);
    NSAssert(shiftedPixelBuffer, @"shiftedPixelBuffer must not be null");
    NSUInteger width = CGImageGetWidth(beforeImage);
    NSUInteger height = CGImageGetHeight(beforeImage);
    uint16_t *histograms = NULL;
    // We only want to perform the relatively expensive rect computation if we've actually
    // been asked for it.
    if (outVisiblePixelRect) {
        histograms = calloc((size_t)(width * height), sizeof(uint16_t));
    }
    GREYVisiblePixelData visiblePixelData = {0, GREYCGPointNull};
    // Make sure we go row-order to take advantage of data locality (cuts runtime in half).
    for (NSUInteger y = 0; y < height; y++) {
        for (NSUInteger x = 0; x < width; x++) {
            NSUInteger currentPixelIndex = (y * width + x) * kColorChannelsPerPixel;
            // We don't care about the first byte because we are dealing with XRGB format.
            BOOL pixelHasDiff = grey_isPixelDifferent(&pixelBuffer[currentPixelIndex + 1],
                                                      &shiftedPixelBuffer[currentPixelIndex + 1]);
            if (pixelHasDiff) {
                visiblePixelData.visiblePixelCount++;
                // Always pick the bottom and right-most pixel. We may want to consider using tax-cab
                // formula to find a pixel that's closest to the center if we encounter problems with this
                // approach.
                visiblePixelData.visiblePixel.x = x;
                visiblePixelData.visiblePixel.y = y;
            }
            if (outVisiblePixelRect) {
                if (y == 0) {
                    histograms[x] = pixelHasDiff ? 1 : 0;
                } else {
                    histograms[y * width + x] = pixelHasDiff ? (histograms[(y - 1) * width + x] + 1) : 0;
                }
            }
            if (outDiffBufferOrNULL) {
                GREYVisibilityDiffBufferSetVisibility(*outDiffBufferOrNULL, x, y, pixelHasDiff);
            }
        }
    }
    if (outVisiblePixelRect) {
        CGRect largestRect = CGRectZero;
        for (NSUInteger idx = 0; idx < height; idx++) {
            CGRect thisLargest =
            [self grey_largestRectInHistogram:&histograms[idx * width]
                                                        length:(uint16_t)width];
            if (CGRectArea(thisLargest) > CGRectArea(largestRect)) {
                // Because our histograms point up, not down.
                thisLargest.origin.y = idx - thisLargest.size.height + 1;
                largestRect = thisLargest;
            }
        }
        *outVisiblePixelRect = largestRect;
        free(histograms);
        histograms = NULL;
    }
    free(pixelBuffer);
    pixelBuffer = NULL;
    free(shiftedPixelBuffer);
    shiftedPixelBuffer = NULL;
    return visiblePixelData;
}

/**
 *  Given a list of values representing a histogram (values are the heights of the bars), this
 *  method returns the largest contiguous rectangle in that histogram.
 *
 *  @param histogram The array of values representing the histogram.
 *  @param length    The number of values in the histogram.
 *
 *  @return A CGRect of the largest rectangle in the given histogram.
 */
+ (CGRect)grey_largestRectInHistogram:(uint16_t *)histogram length:(uint16_t)length {
    uint16_t *leftNeighbors = malloc(sizeof(uint16_t) * length);
    uint16_t *rightNeighbors = malloc(sizeof(uint16_t) * length);
    uint16_t *leftStack = malloc(sizeof(uint16_t) * length);
    uint16_t *rightStack = malloc(sizeof(uint16_t) * length);
    // Index of the last element on the stack.
    NSInteger leftStackIdx = -1;
    NSInteger rightStackIdx = -1;
    CGRect largestRect = CGRectZero;
    CGFloat largestArea = 0;
    // We make two passes at once, one from left to right and one from right to left.
    for (uint16_t idx = 0; idx < length; idx++) {
        uint16_t tailIdx = (length - 1) - idx;
        // Find nearest column shorter than this one on either side.
        while (leftStackIdx >= 0 && histogram[leftStack[leftStackIdx]] >= histogram[idx]) {
            leftStackIdx--;
        }
        while (rightStackIdx >= 0 && histogram[rightStack[rightStackIdx]] >= histogram[tailIdx]) {
            rightStackIdx--;
        }
        // Set the number of columns at least as tall as this one on either side.
        if (leftStackIdx < 0) {
            leftNeighbors[idx] = idx;
        } else {
            leftNeighbors[idx] = idx - leftStack[leftStackIdx] - 1;
        }
        if (rightStackIdx < 0) {
            rightNeighbors[tailIdx] = length - tailIdx - 1;
        } else {
            rightNeighbors[tailIdx] = rightStack[rightStackIdx] - tailIdx - 1;
        }
        // Add the current index to the stack
        leftStack[++leftStackIdx] = idx;
        rightStack[++rightStackIdx] = tailIdx;
    }
    // Now we have the number of histogram bars immediately left and right of each bar that are at
    // least as tall as the given bar. Now we can compute areas easily.
    for (NSUInteger idx = 0; idx < length; idx++) {
        CGFloat area = (leftNeighbors[idx] + rightNeighbors[idx] + 1) * histogram[idx];
        if (area > largestArea) {
            largestArea = area;
            largestRect.origin.x = idx - leftNeighbors[idx];
            largestRect.size.width = leftNeighbors[idx] + rightNeighbors[idx] + 1;
            largestRect.size.height = histogram[idx];
        }
    }
    free(leftStack);
    leftStack = NULL;
    free(rightStack);
    rightStack = NULL;
    free(leftNeighbors);
    leftNeighbors = NULL;
    free(rightNeighbors);
    rightNeighbors = NULL;
    return largestRect;
}

/**
 *  Creates a UIImageView and adds a shifted color image of @c imageRef to it, in addition
 *  view.frame is offset by @c offset and image orientation set to @c orientation. There are 256
 *  possible values for a color component, from 0 to 255. Each color component will be shifted by
 *  exactly 128, examples: 0 => 128, 64 => 192, 128 => 0, 255 => 127.
 *
 *  @param imageRef The image whose colors are to be shifted.
 *  @param offset The frame offset to be applied to resulting view.
 *  @param orientation The target orientation of the image added to the resulting view.
 *
 *  @return A view containing shifted color image of @c imageRef with view.frame offset by
 *          @c offset and orientation set to @c orientation.
 */
+ (UIView *)grey_imageViewWithShiftedColorOfImage:(CGImageRef)imageRef
                                      frameOffset:(CGPoint)offset
                                      orientation:(UIImageOrientation)orientation
{
    NSAssert(imageRef, @"imageRef should not be nil");
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    // TODO: Find a good way to compute imagePixelData of before image only once without
    // negatively impacting the readability of code in visibility checker.
    unsigned char *shiftedImagePixels = grey_createImagePixelDataFromCGImageRef(imageRef, NULL);
    
    for (NSUInteger i = 0; i < height * width; i++) {
        NSUInteger currentPixelIndex = kColorChannelsPerPixel * i;
        // We don't care about the [first] byte of the [X]RGB format.
        for (unsigned char j = 1; j <= 2; j++) {
            static const unsigned char kShiftIntensityAmount[] = {0, 10, 10, 10}; // Shift for X, R, G, B
            unsigned char pixelIntensity = shiftedImagePixels[currentPixelIndex + j];
            if (pixelIntensity >= kShiftIntensityAmount[j]) {
                pixelIntensity = pixelIntensity - kShiftIntensityAmount[j];
            } else {
                pixelIntensity = pixelIntensity + kShiftIntensityAmount[j];
            }
            shiftedImagePixels[currentPixelIndex + j] = pixelIntensity;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext =
    CGBitmapContextCreate(shiftedImagePixels,
                          width,
                          height,
                          8,
                          kColorChannelsPerPixel * width,
                          colorSpace,
                          kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef bitmapImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *shiftedImage = [UIImage imageWithCGImage:bitmapImageRef
                                                scale:[[UIScreen mainScreen] scale]
                                          orientation:orientation];
    
    CGImageRelease(bitmapImageRef);
    CGContextRelease(bitmapContext);
    free(shiftedImagePixels);
    
    UIImageView *shiftedImageView = [[UIImageView alloc] initWithImage:shiftedImage];
    shiftedImageView.frame = CGRectOffset(shiftedImageView.frame, offset.x, offset.y);
    shiftedImageView.opaque = YES;
    return shiftedImageView;
}

/**
 *  @return @c true if the encoded rgb1[R, G, B] color values are different from rbg2[R, G, B]
 *          values, @c false otherwise.
 *  @todo Ideally, we should be testing that pixel colors are shifted by a certain amount instead of
 *        checking if they are simply different. However, the naive check for shifted colors doesn't
 *        work if pixels are overlapped by a translucent mask or have special layer effects applied
 *        to it. Because they are still visible to user and we want to avoid false-negatives that
 *        would cause the test to fail, we resort to a naive check that rbg1 and rgb2 are not the
 *        same without specifying the exact delta between them.
 */
static inline bool grey_isPixelDifferent(unsigned char rgb1[], unsigned char rgb2[]) {
    return (rgb1[0] != rgb2[0]) || (rgb1[1] != rgb2[1]) || (rgb1[2] != rgb2[2]);
}

unsigned char *grey_createImagePixelDataFromCGImageRef(CGImageRef imageRef,
                                                              CGContextRef *outBmpCtx) {
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    unsigned char *imagePixelBuffer = malloc(height * width * kBytesPerPixel);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create the bitmap context. We want XRGB.
    CGContextRef bitmapContextRef =
    CGBitmapContextCreate(imagePixelBuffer,
                          width,
                          height,
                          8, // bits per component
                          width * kBytesPerPixel, // bytes per row
                          colorSpace,
                          kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (!bitmapContextRef) {
        free(imagePixelBuffer);
        return NULL;
    }
    
    // Once we draw, the memory allocated for the context for rendering will then contain the raw
    // image pixel data in the specified color space.
    CGContextDrawImage(bitmapContextRef, CGRectMake(0, 0, width, height), imageRef);
    if (outBmpCtx != NULL) {
        // Caller must call CGContextRelease.
        *outBmpCtx = bitmapContextRef;
    } else {
        CGContextRelease(bitmapContextRef);
    }
    
    // Must be freed by the caller.
    return imagePixelBuffer;
}


@end

#endif
