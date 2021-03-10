#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol VisibilityCheckImageColorShifter {
    func imagePixelDataWithShiftedColors(
        imagePixelData: ImagePixelData,
        targetPixelOfInteraction: IntPoint?,
        visibilityCheckForLoopOptimizer: VisibilityCheckForLoopOptimizer)
        -> ImagePixelData
}

#endif
