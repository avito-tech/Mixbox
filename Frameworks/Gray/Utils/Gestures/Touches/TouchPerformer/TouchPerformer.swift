import MixboxFoundation

public protocol TouchPerformer: class {
    func touch(
        touchPaths: [[CGPoint]],
        relativeToWindow window: UIWindow,
        duration: TimeInterval,
        expendable: Bool)
        throws
}
