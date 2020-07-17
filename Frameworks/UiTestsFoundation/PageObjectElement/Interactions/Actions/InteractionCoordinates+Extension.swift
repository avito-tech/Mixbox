import MixboxIpcCommon
import MixboxUiKit

extension InteractionCoordinates {
    public func interactionCoordinatesOnScreen(elementSnapshot: ElementSnapshot) -> CGPoint {
        return interactionCoordinatesOnScreen(
            elementFrameRelativeToScreen: elementSnapshot.frameRelativeToScreen
        )
    }
}
