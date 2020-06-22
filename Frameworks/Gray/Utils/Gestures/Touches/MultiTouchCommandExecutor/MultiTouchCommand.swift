import Foundation
import UIKit

public final class MultiTouchCommand {
    public final class Begin {
        public let pointsByFinger: [CGPoint]
        
        public init(
            pointsByFinger: [CGPoint])
        {
            self.pointsByFinger = pointsByFinger
        }
    }
    
    public final class Continue {
        public let pointsByFinger: [CGPoint]
        public let timeElapsedSinceLastTouchDelivery: TimeInterval
        // Indicates that this touch point is intended to be delivered in a timely
        // manner rather than reliably. If `false`, touch can be skipped.
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
