#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

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
