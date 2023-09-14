import MixboxIpcCommon

public final class SwipeActionDescriptionProvider {
    private let swipeActionPathSettings: SwipeActionPathSettings
    private let startPoint: InteractionCoordinates
    
    public init(
        swipeActionPathSettings: SwipeActionPathSettings,
        startPoint: InteractionCoordinates)
    {
        self.swipeActionPathSettings = swipeActionPathSettings
        self.startPoint = startPoint
    }
    
    public func swipeActionDescription(elementName: String) -> String {
        return "swipe in \(elementName) \(startPointDescription()) \(endPointDescription())"
    }
    
    private func endPointDescription() -> String {
        switch swipeActionPathSettings.endPoint {
        case let .directionWithDefaultLength(direction):
            return directionDescription(direction: direction)
        case let .directionWithLength(direction, length):
            return "\(directionDescription(direction: direction)) by \(length) points"
        case let .interactionCoordinates(interactionCoordinates):
            return interactionCoordinatesDescription(
                interactionCoordinates: interactionCoordinates,
                preposition: "to",
                nonCenterDescription: "point",
                centerDescription: "center of the element"
            )
        }
    }
    
    private func directionDescription(direction: SwipeDirection) -> String {
        switch direction {
        case .up:
            return "up"
        case .down:
            return "down"
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }
    
    private func startPointDescription() -> String {
        let nonCenterDescription = "point"
        let centerDescription = "center of element"
        
        return interactionCoordinatesDescription(
            interactionCoordinates: startPoint,
            preposition: "from",
            nonCenterDescription: nonCenterDescription,
            centerDescription: centerDescription
        )
    }
    
    private func interactionCoordinatesDescription(
        interactionCoordinates: InteractionCoordinates,
        preposition: String,
        nonCenterDescription: String,
        centerDescription: String)
        -> String
    {
        let normalizedCoordinatesDesription: String
        let absoluteCoordinatesDesription: String?
        
        if let normalizedCoordinate = interactionCoordinates.normalizedCoordinate {
            let x = normalizedCoordinate.x
            let y = normalizedCoordinate.y
            
            if x == 0.5 && y == 0.5 {
                normalizedCoordinatesDesription = "\(preposition) \(centerDescription)"
            } else {
                normalizedCoordinatesDesription = "\(preposition) \(nonCenterDescription) with relative normalized coordinates (\(x); \(y))"
            }
        } else {
            normalizedCoordinatesDesription = "\(preposition) \(centerDescription)"
        }
        
        if let absoluteOffset = interactionCoordinates.absoluteOffset {
            let x = absoluteOffset.dx
            let y = absoluteOffset.dy
            
            absoluteCoordinatesDesription = "with absolute offset (\(x); \(y))"
        } else {
            absoluteCoordinatesDesription = nil
        }
        
        return normalizedCoordinatesDesription + (absoluteCoordinatesDesription.map { " \($0)" } ?? "")
    }
}
