public protocol InteractionCoordinates {
    func interactionCoordinatesOnScreen(elementSnapshot: ElementSnapshot) -> CGPoint
}

// Behaves as in 2018 where there were 2 args in each function.
// Now is 2019 and we might want to use some kind of builder.
public final class InteractionCoordinatesImpl: InteractionCoordinates {
    private let normalizedCoordinate: CGPoint?
    private let absoluteOffset: CGVector?
    
    public init(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil)
    {
        self.normalizedCoordinate = normalizedCoordinate
        self.absoluteOffset = absoluteOffset
    }
    
    // MARK: - InteractionCoordinates
    
    public func interactionCoordinatesOnScreen(elementSnapshot: ElementSnapshot) -> CGPoint {
        var coordinate = elementSnapshot.frameOnScreen.mb_center
        
        if let normalizedCoordinate = normalizedCoordinate {
            coordinate.x += elementSnapshot.frameOnScreen.width * (normalizedCoordinate.x - 0.5)
            coordinate.y += elementSnapshot.frameOnScreen.height * (normalizedCoordinate.y - 0.5)
        }
        
        if let absoluteOffset = absoluteOffset {
            coordinate.x += absoluteOffset.dx
            coordinate.y += absoluteOffset.dy
        }
        
        return coordinate
    }
    
}
