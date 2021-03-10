public final class SwipeActionPathSettings {
    public let endPoint: SwipeActionEndPoint
    public let speed: TouchActionSpeed?
    
    public init(
        endPoint: SwipeActionEndPoint,
        speed: TouchActionSpeed?)
    {
        self.endPoint = endPoint
        self.speed = speed
    }
}
