import MixboxFoundation

public protocol TouchPerformer: class {
    func touch(
        touchPaths: [[CGPoint]],
        relativeToWindow window: UIWindow,
        duration: TimeInterval,
        isExpendable: Bool)
        throws
}
