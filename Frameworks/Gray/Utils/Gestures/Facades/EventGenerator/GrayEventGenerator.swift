import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxUiKit

public final class GrayEventGenerator: EventGenerator {
    private let touchPerformer: TouchPerformer
    private let pathGestureUtils: PathGestureUtils
    
    public init(
        touchPerformer: TouchPerformer,
        pathGestureUtils: PathGestureUtils)
    {
        self.touchPerformer = touchPerformer
        self.pathGestureUtils = pathGestureUtils
    }
    
    public func tap(
        point: CGPoint,
        numberOfTaps: UInt)
        throws
    {
        try (0..<numberOfTaps).forEach { _ in
            try touchPerformer.touch(
                touchPaths: [[point]],
                duration: 0,
                isExpendable: false
            )
        }
    }
    
    public func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        durationOfInitialPress: TimeInterval,
        velocity: Double,
        cancelInertia: Bool)
        throws
    {
        guard durationOfInitialPress == 0 else {
            grayNotImplemented()
        }
        
        // TODO: Test exact duration and speed.
        let durarionOfMoving = TimeInterval((from - to).mb_length() / CGFloat(velocity))
        
        let path = pathGestureUtils.touchPath(
            startPoint: from,
            endPoint: to,
            touchPathLengths: .optimizedForDuration(durarionOfMoving),
            cancelInertia: cancelInertia,
            skipUndetectableScroll: false
        )
        
        try touchPerformer.touch(
            touchPaths: [path],
            duration: durarionOfMoving,
            isExpendable: false
        )
    }
}
