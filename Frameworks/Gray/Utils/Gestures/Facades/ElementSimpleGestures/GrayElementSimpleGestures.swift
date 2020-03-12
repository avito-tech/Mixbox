import MixboxUiTestsFoundation
import MixboxFoundation

public final class GrayElementSimpleGestures: ElementSimpleGestures {
    private let touchPerformer: TouchPerformer
    private let point: CGPoint
    
    public init(
        touchPerformer: TouchPerformer,
        point: CGPoint)
    {
        self.touchPerformer = touchPerformer
        self.point = point
    }
    
    public func tap() throws {
        try touchPerformer.touch(
            touchPaths: [[point]],
            duration: 0,
            isExpendable: false
        )
    }
    
    public func press(duration: TimeInterval) throws {
        try touchPerformer.touch(
            touchPaths: [[point]],
            duration: duration,
            isExpendable: false
        )
    }
    
    private func failedToGetWindowError(eventName: String) -> Error {
        return ErrorString("Failed to get window for synthesizing \(eventName) for point \(point)")
    }
}
