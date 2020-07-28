#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol VisiblePixelDataCalculator {
    // Calculates the number of pixel in `afterImage` that have different pixel intensity than in `beforeImage`.
    //
    // If `storeComparisonResult` is true, a reference for getting the VisibilityDiffBuffer that was
    // created to detect image diff, will be stored to `comparisonResultBuffer`.
    //
    func visiblePixelData(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        searchRectInScreenCoordinates: CGRect,
        targetPointOfInteraction: CGPoint?,
        storeComparisonResult: Bool)
        throws
        -> VisiblePixelData
}

#endif
