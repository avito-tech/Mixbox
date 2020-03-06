// Difference from EnqueuedMultiTouchInfo:
//
// - It has additional phases are to determined by TouchInjector based on its state
// - It has no fields that used for dequeing (`expendable`, `deliveryTimeDeltaSinceLastTouch`).
//
// swiftlint:disable nesting
public class DequeuedMultiTouchInfo {
    public final class TouchInfo {
        public enum Phase {
            case began
            case moved
            case ended
            case cancelled
            case stationary
        }
        
        public let point: CGPoint
        public let phase: Phase
        
        // it is not implemented, but this value is read when events are generated.
        public var pressure: Float? { return nil }
        
        public init(
            point: CGPoint,
            phase: Phase)
        {
            self.point = point
            self.phase = phase
        }
    }
    
    public let touchesByFinger: [TouchInfo]
    
    public init(
        touchesByFinger: [TouchInfo])
    {
        self.touchesByFinger = touchesByFinger
    }
}
