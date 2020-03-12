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
        interactionCoordinates: InteractionCoordinates)
        throws
        -> ElementSimpleGestures
    {
        let point = interactionCoordinates.interactionCoordinatesOnScreen(
            elementSnapshot: elementSnapshot
        )
        
        return GrayElementSimpleGestures(
            touchPerformer: touchPerformer,
            point: point
        )
    }
}
