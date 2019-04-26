import MixboxUiTestsFoundation

public final class GrayElementSimpleGesturesProvider: ElementSimpleGesturesProvider {
    private let touchPerformer: TouchPerformer
    private let windowForPointProvider: WindowForPointProvider
    
    public init(
        touchPerformer: TouchPerformer,
        windowForPointProvider: WindowForPointProvider)
    {
        self.touchPerformer = touchPerformer
        self.windowForPointProvider = windowForPointProvider
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
            point: point,
            windowForPointProvider: windowForPointProvider
        )
    }
}
