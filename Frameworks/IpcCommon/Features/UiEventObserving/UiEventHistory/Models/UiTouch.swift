#if MIXBOX_ENABLE_IN_APP_SERVICES

// Mirrors UIKit.UITouch (incompletely)
public final class UiTouch: Codable {
    // Mirrors UITouch.Phase (completely)
    public enum Phase: String, Codable {
        case began
        case moved
        case stationary
        case ended
        case cancelled
    }
    
    // Mirrors UITouch.TouchType (completely)
    public enum TouchType: String, Codable {
        case direct
        case indirect
        case pencil
    }
    
    public let timestamp: TimeInterval
    public let phase: Phase
    public let tapCount: Int
    public let type: TouchType
    public let majorRadius: CGFloat
    public let majorRadiusTolerance: CGFloat
    public let location: CGPoint
    public let preciseLocation: CGPoint
    
    public init(
        timestamp: TimeInterval,
        phase: Phase,
        tapCount: Int,
        type: TouchType,
        majorRadius: CGFloat,
        majorRadiusTolerance: CGFloat,
        location: CGPoint,
        preciseLocation: CGPoint)
    {
        self.timestamp = timestamp
        self.phase = phase
        self.tapCount = tapCount
        self.type = type
        self.majorRadius = majorRadius
        self.majorRadiusTolerance = majorRadiusTolerance
        self.location = location
        self.preciseLocation = preciseLocation
    }
}

#endif
