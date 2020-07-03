#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class VisibilityCheckImagesCapturerImpl: VisibilityCheckImagesCapturer {
    private let imagePixelDataCreator: ImagePixelDataCreator
    private let inAppScreenshotTaker: InAppScreenshotTaker
    private let colorChannelsPerPixel = 4
    
    public init(
        imagePixelDataCreator: ImagePixelDataCreator,
        inAppScreenshotTaker: InAppScreenshotTaker)
    {
        self.imagePixelDataCreator = imagePixelDataCreator
        self.inAppScreenshotTaker = inAppScreenshotTaker
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func capture(view: UIView, searchRectInScreenCoordinates: CGRect)
        throws
        -> VisibilityCheckImagesCaptureResult
    {
        // A quick visibility check is done here to rule out any definitely hidden views.
        if view.isDefinitelyHidden {
            throw ErrorString("View is not visible")
        }
        
        if searchRectInScreenCoordinates.isEmpty {
            throw ErrorString("searchRectInScreenCoordinates is empty")
        }
        
        // Find portion of search rect that is on screen and in view.
        let screenBounds = UIScreen.main.bounds
        
        let axFrame = view.accessibilityFrame
        let searchRectOnScreenInViewInScreenCoordinates = searchRectInScreenCoordinates.intersection(
            axFrame.intersection(screenBounds)
        )
        
        if searchRectOnScreenInViewInScreenCoordinates.isEmpty {
            throw ErrorString("searchRectOnScreenInViewInScreenCoordinates is empty")
        }
    
        // Calculate the search rectangle for screenshot.
        var screenshotSearchRect_pixel = searchRectOnScreenInViewInScreenCoordinates
        
        screenshotSearchRect_pixel = screenshotSearchRect_pixel.mb_pointToPixel()
        screenshotSearchRect_pixel = screenshotSearchRect_pixel.mb_integralInside()
    
        let intersectionOrigin = screenshotSearchRect_pixel.origin
        
        if screenshotSearchRect_pixel.size.width == 0 || screenshotSearchRect_pixel.size.height == 0 {
            throw ErrorString("screenshotSearchRect has zero area")
        }
    
        // Take an image of what the view looks like before shifting pixel intensity.
        // Ensures that any implicit animations that might have taken place since the last runloop
        // run are committed to the presentation layer.
        // @see
        // http://optshiftk.com/2013/11/better-documentation-for-catransaction-flush/
        CATransaction.begin()
        CATransaction.flush()
        CATransaction.commit()
        
        guard let beforeScreenshot = inAppScreenshotTaker.takeScreenshot(afterScreenUpdates: true) else {
            throw ErrorString("beforeScreenshot is nil")
        }
        
        guard let beforeScreenshotCgImage = beforeScreenshot.cgImage else {
            throw ErrorString("beforeScreenshotCgImage is nil")
        }
        
        guard let beforeImage = beforeScreenshotCgImage.cropping(to: screenshotSearchRect_pixel) else {
            throw ErrorString("beforeImage is nil")
        }
        
        guard let window = view.window else {
            throw ErrorString("Window is nil")
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
        let searchRectOnScreenInViewInWindowCoordinates = window.convert(
            searchRectOnScreenInViewInScreenCoordinates,
            from: nil
        )
        let searchRectOnScreenInViewInViewCoordinates = view.convert(
            searchRectOnScreenInViewInWindowCoordinates,
            from: nil
        )
    
        let rectAfterPixelAlignment = screenshotSearchRect_pixel.mb_pixelToPoint()
        
        let searchRectOnScreenInViewInVariableScreenCoordinates = searchRectOnScreenInViewInScreenCoordinates
        
        let xPixelAlignmentDiff = rectAfterPixelAlignment.minX -
        searchRectOnScreenInViewInVariableScreenCoordinates.minX
        
        let yPixelAlignmentDiff = rectAfterPixelAlignment.minY -
        searchRectOnScreenInViewInVariableScreenCoordinates.minY
    
        let searchRectOffsetX = searchRectOnScreenInViewInViewCoordinates.minX + xPixelAlignmentDiff
        let searchRectOffsetY = searchRectOnScreenInViewInViewCoordinates.minY + yPixelAlignmentDiff
    
        let searchRectOffset = CGPoint(x: searchRectOffsetX, y: searchRectOffsetY)
        
        let shiftedView = try imageViewWithShiftedColor(
            ofImage: beforeImage,
            frameOffset: searchRectOffset,
            orientation: beforeScreenshot.imageOrientation
        )
        
        guard let afterScreenshot = imageAfterAddingSubview(shiftedView: shiftedView, toView: view) else {
            throw ErrorString("afterScreenshot is nil")
        }
        
        guard let afterScreenshotCgImage = afterScreenshot.cgImage else {
            throw ErrorString("afterScreenshotCgImage is nil")
        }
        
        guard let afterImage = afterScreenshotCgImage.cropping(to: screenshotSearchRect_pixel) else {
            throw ErrorString("afterImage should not be null")
        }
        
        return VisibilityCheckImagesCaptureResult(
            beforeImage: beforeImage,
            afterImage: afterImage,
            intersectionOrigin: intersectionOrigin
        )
    }

    private func imageAfterAddingSubview(
        shiftedView: UIView,
        toView view: UIView)
        -> UIImage?
    {
        return prepareViewForVisibilityCheck(view: view) { () -> UIImage? in
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            view.addSubview(shiftedView)

            // It was working for 3 years without this line working.
            // We can implement it (see `grey_keepSubviewOnTopAndFrameFixed` in EarlGray) if needed.
            //[view grey_keepSubviewOnTopAndFrameFixed:shiftedView];
            
            CATransaction.flush()
            CATransaction.commit()
            
            let shiftedImage = inAppScreenshotTaker.takeScreenshot(afterScreenUpdates: true)
            shiftedView.removeFromSuperview()
            
            return shiftedImage
        }
    }
        
    // Prepares `view` for visibility check by modifying visual aspects that interfere with
    // pixel intensities. Then, executes `body`, restores view's properties and returns the result of
    // executing the `body` to the caller.
    private func prepareViewForVisibilityCheck<T>(view: UIView, body: () -> T) -> T {
        let previousValueOfDisableActions = CATransaction.disableActions()
        let previousValueOfShouldRasterize = view.layer.shouldRasterize
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        // Rasterizing causes flakiness by re-drawing the view frame by frame for any layout change and
        // caching it for further use. This brings a delay in refreshing the layout for the shiftedView.
        view.layer.shouldRasterize = false
        
        // Views may be translucent and there have their alpha adjusted to 1.0 when taking the screenshot
        // because the shifted view, being a child of the view, will inherit its opacity. The problem
        // with that is that shifted view is created from a screenshot of the view with its original
        // opacity, so if we just add the shifted view as a subview of view the opacity change will be
        // applied once more. This may result on false negatives, specially on anti-aliased text. To make
        // sure the opacity won't affect the screenshot, we need to apply the change to the view and all
        // of its parents, then reset the changes when done.
        let storedAlphaSettings = view.recursivelyMakeOpaque()
        
        CATransaction.flush()
        CATransaction.commit()
        
        let retVal = body()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        storedAlphaSettings.restore()
        view.layer.shouldRasterize = previousValueOfShouldRasterize
        CATransaction.setDisableActions(previousValueOfDisableActions)
        
        CATransaction.flush()
        CATransaction.commit()
        
        return retVal
    }
    
    // The code below shifts RGB channels by some amount. The idea is that if after shifting colors of view
    // something really changes for user, then this view is visible. If nothing is changed, then it's hidden,
    // overlapped, etc.
    //
    // ----
    //
    // Below this paragraph is the original comment on how this code works. This is not how it was really working!
    // But the idea from the comment seems much better than the current implementation.
    // Current implementation is buggy and doesn't work great for every edge case.
    // The idea from the comment below might work better, but it also doesn't work properly in reality.
    // It would be good if we write tests, checking every combination of views, colors, positions, alpha, etc,
    // and test the actual percentage of visible area vs expected.
    //
    // ----
    //
    // Creates a UIImageView and adds a shifted color image of @c imageRef to it, in addition
    // view.frame is offset by @c offset and image orientation set to @c orientation. There are 256
    // possible values for a color component, from 0 to 255. Each color component will be shifted by
    // exactly 128, examples: 0 => 128, 64 => 192, 128 => 0, 255 => 127.
    //
    // @param imageRef The image whose colors are to be shifted.
    // @param offset The frame offset to be applied to resulting view.
    // @param orientation The target orientation of the image added to the resulting view.
    //
    // @return A view containing shifted color image of @c imageRef with view.frame offset by
    //         @c offset and orientation set to @c orientation.
    //
    private func imageViewWithShiftedColor(
        ofImage image: CGImage,
        frameOffset offset: CGPoint,
        orientation: UIImage.Orientation)
        throws
        -> UIImageView
    {
        let width = image.width
        let height = image.height
        
        // TODO: Find a good way to compute imagePixelData of before image only once without
        // negatively impacting the readability of code in visibility checker.
        let shiftedImagePixels = try imagePixelDataCreator.createImagePixelData(image: image)
        
        for i in 0..<height * width {
            let currentPixelIndex = colorChannelsPerPixel * i
            
            // TODO: Blue channel is missing
            // We don't care about the [first] byte of the [X]RGB format.
            for j in 1...2 {
                let kShiftIntensityAmount: [UInt8] = [0, 10, 10, 10] // Shift for X, R, G, B
                var pixelIntensity = shiftedImagePixels.imagePixelBuffer[currentPixelIndex + j]
                
                if pixelIntensity >= kShiftIntensityAmount[j] {
                    pixelIntensity -= kShiftIntensityAmount[j]
                } else {
                    pixelIntensity += kShiftIntensityAmount[j]
                }
                
                shiftedImagePixels.imagePixelBuffer[currentPixelIndex + j] = pixelIntensity
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapContextOrNil = CGContext(
            data: shiftedImagePixels.imagePixelBuffer.pointer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: colorChannelsPerPixel * width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGImageByteOrderInfo.order32Big.rawValue
        )
        
        // TODO: Move to throwing extension
        guard let bitmapContext = bitmapContextOrNil else {
            throw ErrorString("Failed to create CGContext")
        }
        
        guard let bitmapImage = bitmapContext.makeImage() else {
            throw ErrorString("Failed to makeImage() from CGContext")
        }
        
        let shiftedImage = UIImage(
            cgImage: bitmapImage,
            scale: UIScreen.main.scale,
            orientation: orientation
        )
        
        let shiftedImageView = UIImageView(image: shiftedImage)
        shiftedImageView.frame = shiftedImageView.frame.offsetBy(dx: offset.x, dy: offset.y)
        shiftedImageView.isOpaque = true
        
        return shiftedImageView
    }
}

final class StoredAlphaSettings {
    private var viewsAndSettings = [(UIView, CGFloat)]()
    
    func restore() {
        viewsAndSettings.forEach { view, alpha in
            view.alpha = alpha
        }
    }
    
    func store(view: UIView, alpha: CGFloat) {
        
    }
}

extension UIView {
    func recursivelyMakeOpaque() -> StoredAlphaSettings {
        let storedAlphaSettings = StoredAlphaSettings()
        
        recursivelyMakeOpaque(
            storedAlphaSettings: storedAlphaSettings
        )
        
        return storedAlphaSettings
    }
    
    func recursivelyMakeOpaque(storedAlphaSettings: StoredAlphaSettings) {
        storedAlphaSettings.store(view: self, alpha: alpha)
        
        alpha = 1
    }
}

#endif
