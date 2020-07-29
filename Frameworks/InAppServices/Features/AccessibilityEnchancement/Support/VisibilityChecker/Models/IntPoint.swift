#if MIXBOX_ENABLE_IN_APP_SERVICES

public struct IntPoint: Hashable {
    public var x: Int
    public var y: Int
    
    public init(
        x: Int,
        y: Int)
    {
        self.x = x
        self.y = y
    }
}

#endif
