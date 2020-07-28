#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisiblePixelData {
    public let visiblePixelCount: Int
    public let visiblePixel: CGPoint?
    public let comparisonResultBuffer: VisibilityDiffBuffer?
    
    public init(
        visiblePixelCount: Int,
        visiblePixel: CGPoint?,
        comparisonResultBuffer: VisibilityDiffBuffer?)
    {
        self.visiblePixelCount = visiblePixelCount
        self.visiblePixel = visiblePixel
        self.comparisonResultBuffer = comparisonResultBuffer
    }
}

#endif
