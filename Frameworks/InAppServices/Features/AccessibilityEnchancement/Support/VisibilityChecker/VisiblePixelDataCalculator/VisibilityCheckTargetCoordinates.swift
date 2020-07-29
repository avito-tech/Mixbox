#if MIXBOX_ENABLE_IN_APP_SERVICES

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
