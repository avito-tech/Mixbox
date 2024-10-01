#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import CoreGraphics

public struct VisibilityCheckTargetCoordinates {
    public let targetPixelOfInteraction: IntPoint
    public let targetPointOfInteraction: CGPoint
    
    public init(
        targetPixelOfInteraction: IntPoint,
        targetPointOfInteraction: CGPoint)
    {
        self.targetPixelOfInteraction = targetPixelOfInteraction
        self.targetPointOfInteraction = targetPointOfInteraction
    }
}

#endif
