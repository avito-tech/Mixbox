// Makes interaction with new touches starting at multiple `points`. Touch will be delivered to
// the hit test view in `relativeToWindow` window under point.
//
// Common parameters:
//
// - relativeToWindow:
//
//  The window that contains the coordinates of the touch points.
//
// - points:

//  Multiple points at which the touches are to be made.
//
// - expendable:
//
//  Indicates that this touch point is intended to be delivered in a timely
//  manner rather than reliably.
//
public final class MultiTouchCommand {
    public final class Begin {
        public let pointsByFinger: [CGPoint]
        public let relativeToWindow: UIWindow
        
        public init(
            pointsByFinger: [CGPoint],
            relativeToWindow: UIWindow)
        {
            self.pointsByFinger = pointsByFinger
            self.relativeToWindow = relativeToWindow
        }
    }
    
    public final class Continue {
        public let pointsByFinger: [CGPoint]
        public let timeElapsedSinceLastTouchDelivery: TimeInterval
        public let isExpendable: Bool
        
        public init(
            pointsByFinger: [CGPoint],
            timeElapsedSinceLastTouchDelivery: TimeInterval,
            isExpendable: Bool)
        {
            self.pointsByFinger = pointsByFinger
            self.timeElapsedSinceLastTouchDelivery = timeElapsedSinceLastTouchDelivery
            self.isExpendable = isExpendable
        }
    }
    
    public final class End {
        public let pointsByFinger: [CGPoint]
        public let timeElapsedSinceLastTouchDelivery: TimeInterval
        
        public init(
            pointsByFinger: [CGPoint],
            timeElapsedSinceLastTouchDelivery: TimeInterval)
        {
            self.pointsByFinger = pointsByFinger
            self.timeElapsedSinceLastTouchDelivery = timeElapsedSinceLastTouchDelivery
        }
    }
    
    public let beginCommand: Begin
    public let continueCommands: [Continue]
    public let endCommand: End
    
    public init(
        beginCommand: Begin,
        continueCommands: [Continue],
        endCommand: End)
    {
        self.beginCommand = beginCommand
        self.continueCommands = continueCommands
        self.endCommand = endCommand
    }
}
