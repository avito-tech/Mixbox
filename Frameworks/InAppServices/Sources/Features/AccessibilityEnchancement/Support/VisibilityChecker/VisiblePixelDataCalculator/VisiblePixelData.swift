#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisiblePixelData {
    public let visiblePixelCount: Int
    public let checkedPixelCount: Int
    public let visiblePixel: CGPoint?

    public init(
        visiblePixelCount: Int,
        checkedPixelCount: Int,
        visiblePixel: CGPoint?)
    {
        self.visiblePixelCount = visiblePixelCount
        self.checkedPixelCount = checkedPixelCount
        self.visiblePixel = visiblePixel
    }
}

#endif
