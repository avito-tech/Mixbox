public class EnqueuedMultiTouchInfo {
    public final class TouchInfo {
        public enum Phase {
            case began
            case moved
            case ended
        }
        
        public let point: CGPoint
        public let phase: Phase
        
        public init(
            point: CGPoint,
            phase: Phase)
        {
            self.point = point
            self.phase = phase
        }
    }
    
    public let touchesByFinger: [TouchInfo]
    
    // Delays this touch for specified value since the last touch delivery.
    public let deliveryTimeDeltaSinceLastTouch: TimeInterval
    
    // Indicates that this touch can be dropped if system delivering the touches experiences a
    // lag causing it to miss the expected delivery time
    public let isExpendable: Bool
    
    public init(
        touchesByFinger: [TouchInfo],
        deliveryTimeDeltaSinceLastTouch: TimeInterval,
        isExpendable: Bool)
    {
        self.touchesByFinger = touchesByFinger
        self.deliveryTimeDeltaSinceLastTouch = deliveryTimeDeltaSinceLastTouch
        self.isExpendable = isExpendable
    }
}
