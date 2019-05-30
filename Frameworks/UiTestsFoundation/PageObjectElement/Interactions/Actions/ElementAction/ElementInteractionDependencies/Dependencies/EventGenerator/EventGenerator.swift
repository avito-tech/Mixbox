public protocol EventGenerator: class {
    func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        duration: TimeInterval,
        velocity: Double)
        throws
}
