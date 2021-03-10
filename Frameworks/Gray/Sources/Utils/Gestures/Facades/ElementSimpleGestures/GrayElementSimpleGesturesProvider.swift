import MixboxUiTestsFoundation

public final class GrayElementSimpleGesturesProvider: ElementSimpleGesturesProvider {
    private let touchPerformer: TouchPerformer
    
    public init(
        touchPerformer: TouchPerformer)
    {
        self.touchPerformer = touchPerformer
    }
    
    public func elementSimpleGestures(
        elementSnapshot: ElementSnapshot,
        pointOnScreen: CGPoint)
        throws
        -> ElementSimpleGestures
    {
        return GrayElementSimpleGestures(
            touchPerformer: touchPerformer,
            point: pointOnScreen
        )
    }
}
