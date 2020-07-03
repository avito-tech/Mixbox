#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxFoundation

public final class VisibilityCheckerImpl: VisibilityChecker {
    private let assertionFailureRecorder: AssertionFailureRecorder
    private let visibilityCheckImagesCapturer: VisibilityCheckImagesCapturer
    private let visiblePixelDataCalculator: VisiblePixelDataCalculator
    
    public init(
        assertionFailureRecorder: AssertionFailureRecorder,
        visibilityCheckImagesCapturer: VisibilityCheckImagesCapturer,
        visiblePixelDataCalculator: VisiblePixelDataCalculator)
    {
        self.assertionFailureRecorder = assertionFailureRecorder
        self.visibilityCheckImagesCapturer = visibilityCheckImagesCapturer
        self.visiblePixelDataCalculator = visiblePixelDataCalculator
    }
    
    public func percentElementVisible(view: UIView) -> CGFloat {
        return percentElementVisible(
            view: view,
            rect: view.accessibilityFrame
        )
    }
    
    public func percentElementVisible(
        view: UIView,
        rect searchRectInScreenCoordinates: CGRect)
        -> CGFloat
    {
        do {
            let captureResult = try visibilityCheckImagesCapturer.capture(
                view: view,
                searchRectInScreenCoordinates: searchRectInScreenCoordinates
            )
            
            let percentVisible: CGFloat
            
            // Count number of whole pixels in entire search area, including areas off screen or outside
            // view.
            let searchRectInPixels = searchRectInScreenCoordinates.mb_pointToPixel()
            let countTotalSearchRectPixels = searchRectInPixels.mb_integralInside().mb_area
            
            let visiblePixelData = try visiblePixelDataCalculator.visiblePixelData(
                beforeImage: captureResult.beforeImage,
                afterImage:  captureResult.afterImage,
                storeVisiblePixelRect: false,
                storeComparisonResult: false
            )
            
            percentVisible = CGFloat(visiblePixelData.visiblePixelCount) / countTotalSearchRectPixels
            
            if percentVisible < 0 {
                throw ErrorString("percentVisible should not be negative. Current Percent: \(percentVisible)")
            }
            
            return percentVisible
        } catch {
            return 0
        }
    }
}

#endif
