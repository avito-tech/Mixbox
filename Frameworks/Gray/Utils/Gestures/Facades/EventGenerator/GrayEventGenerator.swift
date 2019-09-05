import MixboxUiTestsFoundation
import MixboxFoundation
import MixboxUiKit

public final class GrayEventGenerator: EventGenerator {
    private let touchPerformer: TouchPerformer
    private let windowForPointProvider: WindowForPointProvider
    private let pathGestureUtils: PathGestureUtils
    
    public init(
        touchPerformer: TouchPerformer,
        windowForPointProvider: WindowForPointProvider,
        pathGestureUtils: PathGestureUtils)
    {
        self.touchPerformer = touchPerformer
        self.windowForPointProvider = windowForPointProvider
        self.pathGestureUtils = pathGestureUtils
    }
    
    public func tap(
        point: CGPoint,
        numberOfTaps: UInt)
        throws
    {
        let window = try self.window(point: point, eventName: "tap")
        
        try (0..<numberOfTaps).forEach { _ in
            try touchPerformer.touch(
                touchPaths: [[point]],
                relativeToWindow: window,
                duration: 0,
                expendable: false
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
        
        let window = try self.window(point: from, eventName: "pressAndDrag")
        
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
            relativeToWindow: window,
            duration: durarionOfMoving,
            expendable: false
        )
    }
    
    // MARK: - Private
    
    private func window(point: CGPoint, eventName: String) throws -> UIWindow {
        return try windowForPointProvider.window(point: point).unwrapOrThrow(
            error: ErrorString("Failed to get window for synthesizing \(eventName) for point \(point)")
        )
    }
}
