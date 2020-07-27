#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxFoundation
import MixboxIpcCommon

// Ways to improve performance:
// - CGContextSetInterpolationQuality(ctx, kCGInterpolationNone)
//   https://stackoverflow.com/a/19327509
// - Grab screenshot using GPU, hold it in GPU and process it in GPU.
//   https://stackoverflow.com/questions/33844130/take-a-snapshot-of-current-screen-with-metal-in-swift
//   https://developer.apple.com/documentation/metal/frame_capture_debugging_tools/capturing_gpu_command_data_programmatically
public final class ViewVisibilityCheckerImpl: ViewVisibilityChecker {
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
    
    public func checkVisibility(arguments: VisibilityCheckerArguments) throws -> VisibilityCheckerResult {
        let searchRectInScreenCoordinates = arguments.view.accessibilityFrame
        
        let captureResult = try visibilityCheckImagesCapturer.capture(
            view: arguments.view,
            searchRectInScreenCoordinates: searchRectInScreenCoordinates
        )
        
        // Count number of whole pixels in entire search area, including areas off screen or outside
        // view.
        let searchRectInPixels = searchRectInScreenCoordinates.mb_pointToPixel()
        let countTotalSearchRectPixels = searchRectInPixels.mb_integralInside().mb_area
        
        let visiblePixelData = try visiblePixelDataCalculator.visiblePixelData(
            beforeImagePixelData: captureResult.beforeImagePixelData,
            afterImagePixelData: captureResult.afterImagePixelData,
            searchRectInScreenCoordinates: searchRectInScreenCoordinates,
            targetPointOfInteraction: targetPointOfInteraction(
                elementFrameRelativeToScreen: searchRectInScreenCoordinates,
                interactionCoordinates: arguments.interactionCoordinates
            ),
            storeVisiblePixelRect: false,
            storeComparisonResult: false
        )
        
        let percentageOfVisibleArea = CGFloat(visiblePixelData.visiblePixelCount) / countTotalSearchRectPixels
        
        if percentageOfVisibleArea < 0 {
            throw ErrorString("percentVisible should not be negative. Current Percent: \(percentageOfVisibleArea)")
        }
        
        return VisibilityCheckerResult(
            percentageOfVisibleArea: percentageOfVisibleArea,
            visibilePointOnScreenClosestToInteractionCoordinates: visiblePixelData.visiblePixel
        )
    }
    
    private func targetPointOfInteraction(
        elementFrameRelativeToScreen: CGRect,
        interactionCoordinates: InteractionCoordinates?)
        -> CGPoint?
    {
        return interactionCoordinates.flatMap { interactionCoordinates in
            switch interactionCoordinates.resolveMode() {
            case .useClosestVisiblePoint:
                return interactionCoordinates.interactionCoordinatesOnScreen(
                    elementFrameRelativeToScreen: elementFrameRelativeToScreen
                )
            case .useSpecifiedPoint:
                return nil
            }
        }
    }
}

#endif
