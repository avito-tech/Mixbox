import UIKit

public protocol EventGenerator: AnyObject {
    func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        durationOfInitialPress: TimeInterval,
        velocity: Double,
        cancelInertia: Bool)
        throws
}
