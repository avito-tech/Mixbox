public final class SwipeActionPathSettings {
    public let startPoint: SwipeActionStartPoint
    public let endPoint: SwipeActionEndPoint
    public let speed: TouchActionSpeed?
    
    public init(
        startPoint: SwipeActionStartPoint,
        endPoint: SwipeActionEndPoint,
        speed: TouchActionSpeed?)
    {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.speed = speed
    }
}
