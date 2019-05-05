public protocol EventGenerator {
    func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        duration: TimeInterval,
        velocity: Double)
        throws
}
