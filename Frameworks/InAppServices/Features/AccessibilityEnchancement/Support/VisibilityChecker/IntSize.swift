#if MIXBOX_ENABLE_IN_APP_SERVICES

public struct IntSize: Equatable {
    public var width: Int
    public var height: Int
    
    public init(
        width: Int,
        height: Int)
    {
        self.width = width
        self.height = height
    }
}

extension IntSize {
    public var area: Int {
        return width * height
    }
}

#endif
