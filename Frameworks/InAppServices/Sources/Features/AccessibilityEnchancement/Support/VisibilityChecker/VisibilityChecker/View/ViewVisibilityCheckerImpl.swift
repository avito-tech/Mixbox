#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxFoundation
import MixboxIpcCommon
import MixboxUiKit

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
    private let visibilityCheckForLoopOptimizerFactory: VisibilityCheckForLoopOptimizerFactory
    private let screen: UIScreen
    
    public init(
        assertionFailureRecorder: AssertionFailureRecorder,
        visibilityCheckImagesCapturer: VisibilityCheckImagesCapturer,
        visiblePixelDataCalculator: VisiblePixelDataCalculator,
        performanceLogger: PerformanceLogger,
        visibilityCheckForLoopOptimizerFactory: VisibilityCheckForLoopOptimizerFactory,
        screen: UIScreen)
    {
        self.assertionFailureRecorder = assertionFailureRecorder
        self.visibilityCheckImagesCapturer = visibilityCheckImagesCapturer
        self.visiblePixelDataCalculator = visiblePixelDataCalculator
        self.performanceLogger = performanceLogger
        self.visibilityCheckForLoopOptimizerFactory = visibilityCheckForLoopOptimizerFactory
        self.screen = screen
    }
    
    public func checkVisibility(arguments: ViewVisibilityCheckerArguments) throws -> ViewVisibilityCheckerResult {
        return try performanceLogger.log(staticName: "VC.check") {
            if arguments.view.mb_testability_isDefinitelyHidden() {
                return notVisibleResult()
            }
            
            let searchRectInScreenCoordinates = arguments.view.mb_frameRelativeToScreen

            let screenBounds = screen.bounds

            // TODO: Add this check in MixboxUiTestssFoundation to not call IPC if not needed?
            //       It seems that something was broken somewhere after recent refactorings, because
            //       this line fixed a bug.
            guard let searchRectAndScreenIntersection = searchRectInScreenCoordinates.mb_intersectionOrNil(screenBounds) else {
                return notVisibleResult()
            }
            
            let percentageOfIntersection = searchRectAndScreenIntersection.mb_area / searchRectInScreenCoordinates.mb_area
            
            let targetPointOfInteraction = self.targetPointOfInteraction(
                elementFrameRelativeToScreen: searchRectInScreenCoordinates,
                interactionCoordinates: arguments.interactionCoordinates
            )
            
            let visibilityCheckForLoopOptimizer = visibilityCheckForLoopOptimizerFactory.visibilityCheckForLoopOptimizer(
                useHundredPercentAccuracy: arguments.useHundredPercentAccuracy
            )
            
            let captureResult = try performanceLogger.log(staticName: "VC.capture") {
                try visibilityCheckImagesCapturer.capture(
                    view: arguments.view,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates,
                    targetPointOfInteraction: targetPointOfInteraction,
                    visibilityCheckForLoopOptimizer: visibilityCheckForLoopOptimizer
                )
            }
            
            let visiblePixelData = try performanceLogger.log(staticName: "VC.calculate") {
                try visiblePixelDataCalculator.visiblePixelData(
                    beforeImagePixelData: captureResult.beforeImagePixelData,
                    afterImagePixelData: captureResult.afterImagePixelData,
                    searchRectInScreenCoordinates: searchRectInScreenCoordinates,
                    screenScale: captureResult.screenScale,
                    visibilityCheckTargetCoordinates: captureResult.visibilityCheckTargetCoordinates,
                    visibilityCheckForLoopOptimizer: visibilityCheckForLoopOptimizer
                )
            }
            
            let percentageOfVisiblePixels = CGFloat(visiblePixelData.visiblePixelCount) / CGFloat(visiblePixelData.checkedPixelCount)
            let percentageOfVisibleArea = percentageOfVisiblePixels * percentageOfIntersection
            
            if percentageOfVisibleArea < 0 {
                throw ErrorString("percentVisible should not be negative. Current Percent: \(percentageOfVisibleArea)")
            }
            
            return ViewVisibilityCheckerResult(
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
    
    private func notVisibleResult() -> ViewVisibilityCheckerResult {
        return ViewVisibilityCheckerResult(
            percentageOfVisibleArea: 0,
            visibilePointOnScreenClosestToInteractionCoordinates: nil
        )
    }
}

#endif
