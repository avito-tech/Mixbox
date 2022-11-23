#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public protocol VisiblePixelDataCalculator {
    // Calculates the number of pixel in `afterImage` that have different pixel intensity than in `beforeImage`.
    func visiblePixelData(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        searchRectInScreenCoordinates: CGRect,
        screenScale: CGFloat,
        visibilityCheckTargetCoordinates: VisibilityCheckTargetCoordinates?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        throws
        -> VisiblePixelData
}

#endif
