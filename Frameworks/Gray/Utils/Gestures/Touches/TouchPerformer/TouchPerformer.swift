import MixboxFoundation

public protocol TouchPerformer {
    func touch(
        touchPaths: [[CGPoint]],
        relativeToWindow window: UIWindow,
        duration: TimeInterval,
        expendable: Bool)
        throws
}
