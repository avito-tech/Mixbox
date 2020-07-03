#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisiblePixelData {
    public let visiblePixelCount: Int
    public let visiblePixel: CGPoint?
    public let visiblePixelRect: CGRect?
    public let comparisonResultBuffer: VisibilityDiffBuffer?
    
    public init(
        visiblePixelCount: Int,
        visiblePixel: CGPoint?,
        visiblePixelRect: CGRect?,
        comparisonResultBuffer: VisibilityDiffBuffer?)
    {
        self.visiblePixelCount = visiblePixelCount
        self.visiblePixel = visiblePixel
        self.visiblePixelRect = visiblePixelRect
        self.comparisonResultBuffer = comparisonResultBuffer
    }
}

#endif
