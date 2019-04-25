public class TouchInfo {
    public enum Phase {
        case began
        case moved
        case ended
    }
    
    // Points where touch should be delivered
    public let points: [CGPoint]
    
    // The phase (began, moved etc) of the touch object.
    public let phase: Phase
    
    // Delays this touch for specified value since the last touch delivery.
    public let deliveryTimeDeltaSinceLastTouch: TimeInterval
    
    // Indicates that this touch can be dropped if system delivering the touches experiences a
    // lag causing it to miss the expected delivery time
    public let expendable: Bool
    
    public init(
        points: [CGPoint],
        phase: Phase,
        deliveryTimeDeltaSinceLastTouch: TimeInterval,
        expendable: Bool)
    {
        self.points = points
        self.phase = phase
        self.deliveryTimeDeltaSinceLastTouch = deliveryTimeDeltaSinceLastTouch
        self.expendable = expendable
    }
}
