extension CGVector {
    public static func mb_init(start: CGPoint, end: CGPoint) -> CGVector {
        return self.init(
            dx: end.x - start.x,
            dy: end.y - start.y
        )
    }
    
    public func mb_length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    public func mb_angle() -> CGFloat {
        return atan2(dy, dx)
    }
    
    public func mb_scaled(scale: CGFloat) -> CGVector {
        return CGVector(
            dx: dx * scale,
            dy: dy * scale
        )
    }
    
    public func mb_normalized() -> CGVector? {
        let length = mb_length()
        
        guard length != 0 else {
            return nil
        }
        
        return mb_scaled(scale: 1.0 / length)
    }
}
