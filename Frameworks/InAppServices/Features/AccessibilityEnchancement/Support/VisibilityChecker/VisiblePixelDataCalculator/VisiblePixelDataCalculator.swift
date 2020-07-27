#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol VisiblePixelDataCalculator {
    // Calculates the number of pixel in `afterImage` that have different pixel intensity than in `beforeImage`.
    //
    // If `storeVisiblePixelRect` is true, it returns stores the smallest rectangle enclosing all shifted pixels
    // in `visiblePixelRect` of the return value. If no shifted pixels are found, `visiblePixelRect` will be `.zero`.
    //
    // If `storeComparisonResult` is true, a reference for getting the VisibilityDiffBuffer that was
    // created to detect image diff, will be stored to `comparisonResultBuffer`.
    //
    func visiblePixelData(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        searchRectInScreenCoordinates: CGRect,
        targetPointOfInteraction: CGPoint?,
        storeVisiblePixelRect: Bool,
        storeComparisonResult: Bool)
        throws
        -> VisiblePixelData
}

#endif
