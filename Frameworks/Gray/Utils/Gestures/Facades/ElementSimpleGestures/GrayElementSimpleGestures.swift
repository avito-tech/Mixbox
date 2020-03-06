import MixboxUiTestsFoundation
import MixboxFoundation

public final class GrayElementSimpleGestures: ElementSimpleGestures {
    private let touchPerformer: TouchPerformer
    private let point: CGPoint
    private let windowForPointProvider: WindowForPointProvider
    
    public init(
        touchPerformer: TouchPerformer,
        point: CGPoint,
        windowForPointProvider: WindowForPointProvider)
    {
        self.touchPerformer = touchPerformer
        self.point = point
        self.windowForPointProvider = windowForPointProvider
    }
    
    public func tap() throws {
        try touchPerformer.touch(
            touchPaths: [[point]],
            relativeToWindow: window().unwrapOrThrow(
                error: failedToGetWindowError(eventName: "tap()")
            ),
            duration: 0,
            isExpendable: false
        )
    }
    
    public func press(duration: TimeInterval) throws {
        try touchPerformer.touch(
            touchPaths: [[point]],
            relativeToWindow: window().unwrapOrThrow(
                error: failedToGetWindowError(eventName: "press(duration:)")
            ),
            duration: duration,
            isExpendable: false
        )
    }
    
    private func failedToGetWindowError(eventName: String) -> Error {
        return ErrorString("Failed to get window for synthesizing \(eventName) for point \(point)")
    }
    
    // MARK: - Private
    
    private func window() -> UIWindow? {
        return windowForPointProvider.window(point: point)
    }
}
