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
                error: ErrorString("Failed to get window for synthesizing tap() for point \(point)")
            ),
            duration: 0,
            expendable: false
        )
    }
    
    public func doubleTap() {
        grayNotImplemented()
    }
    
    public func press(duration: TimeInterval) {
        grayNotImplemented()
    }
    
    // MARK: - Private
    
    private func window() -> UIWindow? {
        return windowForPointProvider.window(point: point)
    }
}
