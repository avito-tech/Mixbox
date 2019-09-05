public protocol EventGenerator: class {
    func pressAndDrag(
        from: CGPoint,
        to: CGPoint,
        durationOfInitialPress: TimeInterval,
        velocity: Double,
        cancelInertia: Bool)
        throws
}
