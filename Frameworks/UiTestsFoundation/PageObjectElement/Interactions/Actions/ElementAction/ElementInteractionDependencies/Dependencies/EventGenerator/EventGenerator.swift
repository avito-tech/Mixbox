public protocol EventGenerator {
    func pressAndDrag(from: CGPoint, to: CGPoint, duration: TimeInterval, velocity: Double)
    func tap(point: CGPoint, numberOfTaps: UInt)
}

public extension EventGenerator {
    func tap(point: CGPoint) {
        tap(point: point, numberOfTaps: 1)
    }
}
