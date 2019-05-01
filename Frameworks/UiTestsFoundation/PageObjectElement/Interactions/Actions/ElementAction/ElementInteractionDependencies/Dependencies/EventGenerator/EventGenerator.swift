public protocol EventGenerator {
    func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        duration: TimeInterval,
        velocity: Double)
        throws
    
    func tap(
        point: CGPoint,
        numberOfTaps: UInt)
        throws
}

public extension EventGenerator {
    func tap(point: CGPoint) throws {
        try tap(point: point, numberOfTaps: 1)
    }
}
