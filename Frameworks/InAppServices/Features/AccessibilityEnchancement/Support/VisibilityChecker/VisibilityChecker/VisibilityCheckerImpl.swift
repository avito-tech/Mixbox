#if MIXBOX_ENABLE_IN_APP_SERVICES

import UIKit
import MixboxFoundation
import MixboxIpcCommon

// Notes:
//
// Ways to improve performance:
//
// - CGContextSetInterpolationQuality(ctx, kCGInterpolationNone)
//   https://stackoverflow.com/a/19327509
// - Use `afterScreenUpdates: false` instead of true.
//   This and kCGInterpolationNone gave 6% boost, but more thorough research is needed.
// - Grab screenshot using GPU, hold it in GPU and process it in GPU.
//   https://stackoverflow.com/questions/33844130/take-a-snapshot-of-current-screen-with-metal-in-swift
//   https://developer.apple.com/documentation/metal/frame_capture_debugging_tools/capturing_gpu_command_data_programmatically
//
// Ways not to improve performance (verified):
//
// - @inline
// - Compiler optimizations
// - Disabling safety checks in compiler options
//
public final class ViewVisibilityCheckerImpl: ViewVisibilityChecker {
    private let assertionFailureRecorder: AssertionFailureRecorder
    private let visibilityCheckImagesCapturer: VisibilityCheckImagesCapturer
    private let visiblePixelDataCalculator: VisiblePixelDataCalculator
    private let performanceLogger: PerformanceLogger
    
    public init(
        assertionFailureRecorder: AssertionFailureRecorder,
        visibilityCheckImagesCapturer: VisibilityCheckImagesCapturer,
        visiblePixelDataCalculator: VisiblePixelDataCalculator,
        performanceLogger: PerformanceLogger)
    {
        self.assertionFailureRecorder = assertionFailureRecorder
        self.visibilityCheckImagesCapturer = visibilityCheckImagesCapturer
        self.visiblePixelDataCalculator = visiblePixelDataCalculator
        self.performanceLogger = performanceLogger
    }
    
    public func checkVisibility(arguments: VisibilityCheckerArguments) throws -> VisibilityCheckerResult {
        return try performanceLogger.log(staticName: "VC.check") {
            let searchRectInScreenCoordinates = arguments.view.accessibilityFrame
            
            let targetPointOfInteraction = self.targetPointOfInteraction(
                elementFrameRelativeToScreen: searchRectInScreenCoordinates,
                interactionCoordinates: arguments.interactionCoordinates
            )
            
            let captureResult = try performanceLogger.log(staticName: "VC.capture") {
                try visibilityCheckImagesCapturer.capture(
                    view: arguments.view,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates,
                    targetPointOfInteraction: targetPointOfInteraction
                )
            }
            
            let visiblePixelData = try performanceLogger.log(staticName: "VC.calculate") {
                try visiblePixelDataCalculator.visiblePixelData(
                    beforeImagePixelData: captureResult.beforeImagePixelData,
                    afterImagePixelData: captureResult.afterImagePixelData,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates,
                    screenScale: captureResult.screenScale,
                    visibilityCheckTargetCoordinates: captureResult.visibilityCheckTargetCoordinates
                )
            }
            
            let percentageOfVisibleArea = CGFloat(visiblePixelData.visiblePixelCount) / CGFloat(visiblePixelData.checkedPixelCount)
            
            if percentageOfVisibleArea < 0 {
                throw ErrorString("percentVisible should not be negative. Current Percent: \(percentageOfVisibleArea)")
            }
            
            return VisibilityCheckerResult(
                percentageOfVisibleArea: percentageOfVisibleArea,
                visibilePointOnScreenClosestToInteractionCoordinates: visiblePixelData.visiblePixel
            )
        }
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
