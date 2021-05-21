#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation
import MixboxUiKit

// TODO: Split this class.
public final class VisibilityCheckImagesCapturerImpl: VisibilityCheckImagesCapturer {
    private let imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator
    private let inAppScreenshotTaker: InAppScreenshotTaker
    private let imageFromImagePixelDataCreator: ImageFromImagePixelDataCreator
    private let screen: UIScreen
    private let performanceLogger: PerformanceLogger
    private let visibilityCheckImageColorShifter: VisibilityCheckImageColorShifter
    
    public init(
        imagePixelDataFromImageCreator: ImagePixelDataFromImageCreator,
        inAppScreenshotTaker: InAppScreenshotTaker,
        imageFromImagePixelDataCreator: ImageFromImagePixelDataCreator,
        screen: UIScreen,
        performanceLogger: PerformanceLogger,
        visibilityCheckImageColorShifter: VisibilityCheckImageColorShifter)
    {
        self.imagePixelDataFromImageCreator = imagePixelDataFromImageCreator
        self.inAppScreenshotTaker = inAppScreenshotTaker
        self.imageFromImagePixelDataCreator = imageFromImagePixelDataCreator
        self.screen = screen
        self.performanceLogger = performanceLogger
        self.visibilityCheckImageColorShifter = visibilityCheckImageColorShifter
    }
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func capture(
        view: UIView,
        searchRectInScreenCoordinates: CGRect,
        targetPointOfInteraction: CGPoint?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        throws
        -> VisibilityCheckImagesCaptureResult
    {
        let preconditionMetric = performanceLogger.start(staticName: "VC.capture.precond")
        
        // A quick visibility check is done here to rule out any definitely hidden views.
        if view.mb_testability_isDefinitelyHidden() {
            throw ErrorString("View is not visible")
        }
        
        if searchRectInScreenCoordinates.isEmpty {
            throw ErrorString("searchRectInScreenCoordinates is empty")
        }
        
        // Find portion of search rect that is on screen and in view.
        let screenBounds = screen.bounds
        
        let searchRectOnScreenInViewInScreenCoordinates = searchRectInScreenCoordinates.intersection(
            view.mb_frameRelativeToScreen.intersection(screenBounds)
        )
        
        if searchRectOnScreenInViewInScreenCoordinates.isEmpty {
            throw ErrorString("searchRectOnScreenInViewInScreenCoordinates is empty")
        }
    
        // Calculate the search rectangle for screenshot.
        let screenshotSearchRectInPixels = searchRectOnScreenInViewInScreenCoordinates
            .mb_pointToPixel(scale: screen.scale)
            .mb_integralInside()
    
        let intersectionOrigin = screenshotSearchRectInPixels.origin
        
        if screenshotSearchRectInPixels.size.width == 0 || screenshotSearchRectInPixels.size.height == 0 {
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
        
        preconditionMetric.stop()
        
        let screenshotBeforeMetric = performanceLogger.start(staticName: "VC.capture.snapshot")
        
        guard let beforeScreenshot = inAppScreenshotTaker.takeScreenshot(afterScreenUpdates: true) else {
            throw ErrorString("beforeScreenshot is nil")
        }
        
        guard let beforeScreenshotCgImage = beforeScreenshot.cgImage else {
            throw ErrorString("beforeScreenshotCgImage is nil")
        }
        
        guard let beforeImage = beforeScreenshotCgImage.cropping(to: screenshotSearchRectInPixels) else {
            throw ErrorString("beforeImage is nil")
        }
        
        screenshotBeforeMetric.stop()
        
        let shiftingColorsMetric = performanceLogger.start(staticName: "VC.capture.shift")
        
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
    
        let rectAfterPixelAlignment = screenshotSearchRectInPixels.mb_pixelToPoint(scale: screen.scale)
        
        let searchRectOnScreenInViewInVariableScreenCoordinates = searchRectOnScreenInViewInScreenCoordinates
        
        let xPixelAlignmentDiff = rectAfterPixelAlignment.minX -
        searchRectOnScreenInViewInVariableScreenCoordinates.minX
        
        let yPixelAlignmentDiff = rectAfterPixelAlignment.minY -
        searchRectOnScreenInViewInVariableScreenCoordinates.minY
    
        let searchRectOffsetX = searchRectOnScreenInViewInViewCoordinates.minX + xPixelAlignmentDiff
        let searchRectOffsetY = searchRectOnScreenInViewInViewCoordinates.minY + yPixelAlignmentDiff
    
        let searchRectOffset = CGPoint(x: searchRectOffsetX, y: searchRectOffsetY)
        
        let beforeImagePixelData = try imagePixelDataFromImageCreator.createImagePixelData(image: beforeImage)
        
        let visibilityCheckTargetCoordinates = targetPointOfInteraction.map { targetPointOfInteraction in
            VisibilityCheckTargetCoordinates(
                targetPixelOfInteraction: targetPixelOfInteraction(
                     targetPointOfInteraction: targetPointOfInteraction,
                     imageSize: beforeImagePixelData.size,
                     searchRectInScreenCoordinates: searchRectInScreenCoordinates
                ),
                targetPointOfInteraction: targetPointOfInteraction
            )
        }
        
        let shiftedView = try imageViewWithShiftedColor(
            beforeImagePixelData: beforeImagePixelData,
            frameOffset: searchRectOffset,
            orientation: beforeScreenshot.imageOrientation,
            targetPixelOfInteraction: visibilityCheckTargetCoordinates?.targetPixelOfInteraction,
            visibilityCheckForLoopOptimizer: visibilityCheckForLoopOptimizer
        )
        
        shiftingColorsMetric.stop()
        
        let screenshotAfterMetric = performanceLogger.start(staticName: "VC.capture.snapshot")
        
        guard let afterScreenshot = imageAfterAddingSubview(shiftedView: shiftedView, toView: view) else {
            throw ErrorString("afterScreenshot is nil")
        }
        
        guard let afterScreenshotCgImage = afterScreenshot.cgImage else {
            throw ErrorString("afterScreenshotCgImage is nil")
        }
        
        guard let afterImage = afterScreenshotCgImage.cropping(to: screenshotSearchRectInPixels) else {
            throw ErrorString("afterImage should not be null")
        }
        
        let afterImagePixelData = try imagePixelDataFromImageCreator.createImagePixelData(image: afterImage)
        
        screenshotAfterMetric.stop()
        
        return VisibilityCheckImagesCaptureResult(
            beforeImagePixelData: beforeImagePixelData,
            afterImagePixelData: afterImagePixelData,
            intersectionOrigin: intersectionOrigin,
            visibilityCheckTargetCoordinates: visibilityCheckTargetCoordinates,
            screenScale: screen.scale
        )
    }
    
    private func intRectForCropping(pixelRect: CGRect) -> IntRect {
        return pixelRect.mb_rounded()
    }

    private func imageAfterAddingSubview(
        shiftedView: UIView,
        toView view: UIView)
        -> UIImage?
    {
        return prepareViewForVisibilityCheck(view: view) {
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
    
    private func imageViewWithShiftedColor(
        beforeImagePixelData: ImagePixelData,
        frameOffset offset: CGPoint,
        orientation: UIImage.Orientation,
        targetPixelOfInteraction: IntPoint?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        throws
        -> UIImageView
    {
        let shiftedImagePixels = visibilityCheckImageColorShifter.imagePixelDataWithShiftedColors(
            imagePixelData: beforeImagePixelData,
            targetPixelOfInteraction: targetPixelOfInteraction,
            visibilityCheckForLoopOptimizer: visibilityCheckForLoopOptimizer
        )
        
        let shiftedImage = try imageFromImagePixelDataCreator.image(
            imagePixelData: shiftedImagePixels,
            scale: screen.scale,
            orientation: orientation
        )
        
        let shiftedImageView = UIImageView(image: shiftedImage)
        shiftedImageView.frame = shiftedImageView.frame.offsetBy(dx: offset.x, dy: offset.y)
        shiftedImageView.isOpaque = true
        
        return shiftedImageView
    }
    
    private func targetPixelOfInteraction(
        targetPointOfInteraction: CGPoint,
        imageSize: IntSize,
        searchRectInScreenCoordinates: CGRect)
        -> IntPoint
    {
        // TODO: Make check for division by zero more obvious, don't forget it
        // after rewriting the code (improvement of performance was planned).
        // Currently the check is located in another class (VisibilityCheckImagesCapturer).
        // Same for `func visiblePixel`.
        let offsetInView = targetPointOfInteraction - searchRectInScreenCoordinates.origin
        
        return IntPoint(
            x: Int(offsetInView.dx / searchRectInScreenCoordinates.width * CGFloat(imageSize.width)),
            y: Int(offsetInView.dy / searchRectInScreenCoordinates.height * CGFloat(imageSize.height))
        )
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
