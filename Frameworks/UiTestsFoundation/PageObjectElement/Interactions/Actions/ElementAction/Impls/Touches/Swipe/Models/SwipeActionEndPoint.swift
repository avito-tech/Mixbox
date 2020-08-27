import MixboxIpcCommon
import UIKit

public enum SwipeActionEndPoint {
    case directionWithDefaultLength(SwipeDirection)
    case directionWithLength(SwipeDirection, CGFloat)
    case interactionCoordinates(InteractionCoordinates)
}
