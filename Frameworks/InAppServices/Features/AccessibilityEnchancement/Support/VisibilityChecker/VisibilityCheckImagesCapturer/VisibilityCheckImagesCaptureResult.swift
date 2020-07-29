#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisibilityCheckImagesCaptureResult {
    public let beforeImagePixelData: ImagePixelData
    public let afterImagePixelData: ImagePixelData
    public let intersectionOrigin: CGPoint
    public let visibilityCheckTargetCoordinates: VisibilityCheckTargetCoordinates?
    public let screenScale: CGFloat
    
    public init(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        intersectionOrigin: CGPoint,
        visibilityCheckTargetCoordinates: VisibilityCheckTargetCoordinates?,
        screenScale: CGFloat)
    {
        self.beforeImagePixelData = beforeImagePixelData
        self.afterImagePixelData = afterImagePixelData
        self.intersectionOrigin = intersectionOrigin
        self.visibilityCheckTargetCoordinates = visibilityCheckTargetCoordinates
        self.screenScale = screenScale
    }
}

#endif
