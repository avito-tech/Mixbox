#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class VisibilityCheckImagesCaptureResult {
    public let beforeImage: CGImage
    public let afterImage: CGImage
    public let intersectionOrigin: CGPoint
    
    public init(
        beforeImage: CGImage,
        afterImage: CGImage,
        intersectionOrigin: CGPoint)
    {
        self.beforeImage = beforeImage
        self.afterImage = afterImage
        self.intersectionOrigin = intersectionOrigin
    }
}

#endif
