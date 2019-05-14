extension CGPoint {
    public func mb_asVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    public func mb_distanceTo(_ other: CGPoint) -> CGFloat {
        return CGVector.mb_init(start: self, end: other).mb_length()
    }
    
    public func mb_angleTo(endPoint: CGPoint, anchorPoint: CGPoint) -> CGFloat {
        let startPoint = self
        
        let startAngle = CGVector.mb_init(start: anchorPoint, end: startPoint).mb_angle()
        let endAngle = CGVector.mb_init(start: anchorPoint, end: endPoint).mb_angle()
        
        return CGFloat(endAngle - startAngle)
    }
    
    public func mb_addVector(point: CGPoint, vector: CGVector) -> CGPoint {
        return CGPoint(x: x + vector.dx, y: y + vector.dy)
    }
    
    // MARK: - Rounding
    
    public func mb_ceil() -> CGPoint {
        return CGPoint(
            x: CoreGraphics.ceil(x),
            y: CoreGraphics.ceil(y)
        )
    }
    
    public func mb_floor() -> CGPoint {
        return CGPoint(
            x: CoreGraphics.floor(x),
            y: CoreGraphics.floor(y)
        )
    }
}
