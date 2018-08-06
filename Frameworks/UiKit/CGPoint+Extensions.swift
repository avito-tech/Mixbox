// E.g.: For offsetting
public func +(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x + right.dx,
        y: left.y + right.dy
    )
}

// E.g.: For offsetting
public func +(left: CGVector, right: CGPoint) -> CGPoint {
    return right + left
}

// E.g.: For offsetting
public func -(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x - right.dx,
        y: left.y - right.dy
    )
}

// E.g.: For calculating offset
public func -(left: CGPoint, right: CGPoint) -> CGVector {
    return CGVector(
        dx: left.x - right.x,
        dy: left.y - right.y
    )
}

// Inverting
public prefix func -(vector: CGVector) -> CGVector {
    return CGVector(
        dx: -vector.dx,
        dy: -vector.dy
    )
}

// E.g.: Scaling
// (100pt, 100pt) * (2,2) = (200pt,200pt)
public func *(left: CGSize, right: CGVector) -> CGSize {
    return CGSize(
        width: left.width * right.dx,
        height: left.height * right.dy
    )
}

public func *(left: CGVector, right: CGSize) -> CGSize {
    return right * left
}

// E.g.: Scaling
// (100pt, 100pt) * (2,2) = (200pt,200pt)
public func *(left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(
        x: left.x * right.dx,
        y: left.y * right.dy
    )
}

public func *(left: CGVector, right: CGPoint) -> CGPoint {
    return right * left
}

// E.g.: Scaling
// (200pt, 200pt) / (2,2) = (100pt,100pt)
public func /(left: CGSize, right: CGVector) -> CGSize {
    return CGSize(
        width: left.width / right.dx,
        height: left.height / right.dy
    )
}

// E.g.: Scaling
public func *(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(
        dx: left.dx * right,
        dy: left.dy * right
    )
}

public func *(left: CGFloat, right: CGVector) -> CGVector {
    return right * left
}

// E.g.: Scaling
public func /(left: CGVector, right: CGFloat) -> CGVector {
    return CGVector(
        dx: left.dx / right,
        dy: left.dy / right
    )
}

// E.g.: Ratio
// (100pt, 100pt) / (100pt, 100pt) = (1, 1)
public func /(left: CGVector, right: CGSize) -> CGVector {
    return CGVector(
        dx: left.dx / right.width,
        dy: left.dy / right.height
    )
}

public extension CGPoint {
    func mb_asVector() -> CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    func mb_distanceTo(_ other: CGPoint) -> CGFloat {
        return CGVector(start: self, end: other).mb_length()
    }
    
    func mb_angleTo(endPoint: CGPoint, anchorPoint: CGPoint) -> CGFloat {
        let startPoint = self
        
        let startAngle = CGVector(start: anchorPoint, end: startPoint).mb_angle()
        let endAngle = CGVector(start: anchorPoint, end: endPoint).mb_angle()
        
        return CGFloat(endAngle - startAngle)
    }
    
    func mb_ceil() -> CGPoint {
        return CGPoint(x: CoreGraphics.ceil(x), y: CoreGraphics.ceil(y))
    }
}

public extension CGVector {
    init(start: CGPoint, end: CGPoint) {
        dx = end.x - start.x
        dy = end.y - start.y
    }
    
    func mb_length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    func mb_angle() -> CGFloat {
        return atan2(dy, dx)
    }
}
