import MixboxIpcCommon
import MixboxUiKit
import UIKit

extension InteractionCoordinates {
    public func interactionCoordinatesOnScreen(elementSnapshot: ElementSnapshot) -> CGPoint {
        return interactionCoordinatesOnScreen(
            elementFrameRelativeToScreen: elementSnapshot.frameRelativeToScreen
        )
    }
}
