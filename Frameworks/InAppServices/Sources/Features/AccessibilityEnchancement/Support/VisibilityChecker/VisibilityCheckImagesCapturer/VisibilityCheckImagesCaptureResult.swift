#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import CoreGraphics

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
