public final class InteractionCoordinates {
    public let normalizedCoordinate: CGPoint?
    public let absoluteOffset: CGVector?
    
    public init(
        normalizedCoordinate: CGPoint? = nil,
        absoluteOffset: CGVector? = nil)
    {
        self.normalizedCoordinate = normalizedCoordinate
        self.absoluteOffset = absoluteOffset
    }
    
    public static let center = InteractionCoordinates(normalizedCoordinate: nil, absoluteOffset: nil)
    
    // MARK: - InteractionCoordinates
    
    public func interactionCoordinatesOnScreen(elementSnapshot: ElementSnapshot) -> CGPoint {
        var coordinate = elementSnapshot.frameRelativeToScreen.mb_center
        
        if let normalizedCoordinate = normalizedCoordinate {
            coordinate.x += elementSnapshot.frameRelativeToScreen.width * (normalizedCoordinate.x - 0.5)
            coordinate.y += elementSnapshot.frameRelativeToScreen.height * (normalizedCoordinate.y - 0.5)
        }
        
        if let absoluteOffset = absoluteOffset {
            coordinate.x += absoluteOffset.dx
            coordinate.y += absoluteOffset.dy
        }
        
        return coordinate
    }
    
}
