#if MIXBOX_ENABLE_IN_APP_SERVICES

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
