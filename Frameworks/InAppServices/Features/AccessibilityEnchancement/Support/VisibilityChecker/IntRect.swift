#if MIXBOX_ENABLE_IN_APP_SERVICES

public struct IntRect {
    public var origin: IntPoint
    public var size: IntSize
    
    public init(
        origin: IntPoint,
        size: IntSize)
    {
        self.origin = origin
        self.size = size
    }
}

extension IntRect {
    public var height: Int {
        return size.height
    }
    
    public var width: Int {
        return size.width
    }
    
    public var minY: Int {
        return origin.y
    }
    
    public var maxY: Int {
        return minY + height
    }
    
    public var minX: Int {
        return origin.x
    }
    
    public var maxX: Int {
        return minX + width
    }
}

#endif
