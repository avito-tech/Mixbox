#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisibilityCheckImagesCaptureResult {
    public let beforeImagePixelData: ImagePixelData
    public let afterImagePixelData: ImagePixelData
    public let intersectionOrigin: CGPoint
    
    public init(
        beforeImagePixelData: ImagePixelData,
        afterImagePixelData: ImagePixelData,
        intersectionOrigin: CGPoint)
    {
        self.beforeImagePixelData = beforeImagePixelData
        self.afterImagePixelData = afterImagePixelData
        self.intersectionOrigin = intersectionOrigin
    }
}

#endif
