import MixboxUiKit
import MixboxIpcCommon
import UIKit

public final class SwipeActionPathCalculator {
    public static let defaultVelocity: CGFloat = 2000
    public static let defaultSwipeLengthForSwipingToDirection: CGFloat = 100
    
    private let swipeActionPathSettings: SwipeActionPathSettings
    
    public init(swipeActionPathSettings: SwipeActionPathSettings) {
        self.swipeActionPathSettings = swipeActionPathSettings
    }
    
    public func path(
        elementSnapshot: ElementSnapshot,
        startPoint: CGPoint)
        -> SwipeActionPath
    {
        let endPoint = self.endPoint(
            elementSnapshot: elementSnapshot,
            startPoint: startPoint
        )
        
        let pathLength = (endPoint - startPoint).mb_length()
        
        let speed = swipeActionPathSettings.speed ?? .velocity(SwipeActionPathCalculator.defaultVelocity)
        let velocity = speed.velocity(pathLength: pathLength)
        
        return SwipeActionPath(
            startPoint: startPoint,
            endPoint: endPoint,
            velocity: Double(velocity)
        )
    }
    
    private func endPoint(
        elementSnapshot: ElementSnapshot,
        startPoint: CGPoint)
        -> CGPoint
    {
        switch swipeActionPathSettings.endPoint {
        case let .directionWithDefaultLength(swipeDirection):
            return endPoint(
                startPoint: startPoint,
                swipeDirection: swipeDirection,
                length: SwipeActionPathCalculator.defaultSwipeLengthForSwipingToDirection
            )
        case let .directionWithLength(swipeDirection, length):
            return endPoint(
                startPoint: startPoint,
                swipeDirection: swipeDirection,
                length: length
            )
        case let .interactionCoordinates(interactionCoordinates):
            return interactionCoordinates.interactionCoordinatesOnScreen(
                elementSnapshot: elementSnapshot
            )
        }
    }
    
    private func endPoint(
        startPoint: CGPoint,
        swipeDirection: SwipeDirection,
        length: CGFloat)
        -> CGPoint
    {
        return startPoint + normalizedOffsetForSwipe(swipeDirection: swipeDirection) * length
    }
    
    private func normalizedOffsetForSwipe(swipeDirection: SwipeDirection) -> CGVector {
        let dxNormalized: CGFloat
        let dyNormalized: CGFloat
        
        switch swipeDirection {
        case .up:
            dxNormalized = 0
            dyNormalized = -1
        case .down:
            dxNormalized = 0
            dyNormalized = 1
        case .left:
            dxNormalized = -1
            dyNormalized = 0
        case .right:
            dxNormalized = 1
            dyNormalized = 0
        }
        
        return CGVector(
            dx: dxNormalized,
            dy: dyNormalized
        )
    }
}
