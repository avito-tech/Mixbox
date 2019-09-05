public final class SwipeActionPath {
    public let startPoint: CGPoint
    public let endPoint: CGPoint
    public let velocity: Double
    
    public init(
        startPoint: CGPoint,
        endPoint: CGPoint,
        velocity: Double)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.velocity = velocity
    }
}
