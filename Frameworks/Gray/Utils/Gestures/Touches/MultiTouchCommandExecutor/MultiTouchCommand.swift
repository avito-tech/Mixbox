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
// - waitUntilAllTouchesAreDelivered:
//
//  if true, this method blocks until touches are delivered, otherwise it is
//  enqueued for delivery the next time runloop drains.
//
// - expendable:
//
//  Indicates that this touch point is intended to be delivered in a timely
//  manner rather than reliably.
//
public final class MultiTouchCommand {
    public final class Begin {
        public let points: [CGPoint]
        public let relativeToWindow: UIWindow
        public let waitUntilAllTouchesAreDelivered: Bool
        
        public init(
            points: [CGPoint],
            relativeToWindow: UIWindow,
            waitUntilAllTouchesAreDelivered: Bool)
        {
            self.points = points
            self.relativeToWindow = relativeToWindow
            self.waitUntilAllTouchesAreDelivered = waitUntilAllTouchesAreDelivered
        }
    }
    
    public final class Continue {
        public let points: [CGPoint]
        public let timeElapsedSinceLastTouchDelivery: TimeInterval
        public let waitUntilAllTouchesAreDelivered: Bool
        public let expendable: Bool
        
        public init(
            points: [CGPoint],
            timeElapsedSinceLastTouchDelivery: TimeInterval,
            waitUntilAllTouchesAreDelivered: Bool,
            expendable: Bool)
        {
            self.points = points
            self.timeElapsedSinceLastTouchDelivery = timeElapsedSinceLastTouchDelivery
            self.waitUntilAllTouchesAreDelivered = waitUntilAllTouchesAreDelivered
            self.expendable = expendable
        }
    }
    
    public final class End {
        public let points: [CGPoint]
        public let timeElapsedSinceLastTouchDelivery: TimeInterval
        
        public init(
            points: [CGPoint],
            timeElapsedSinceLastTouchDelivery: TimeInterval)
        {
            self.points = points
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
