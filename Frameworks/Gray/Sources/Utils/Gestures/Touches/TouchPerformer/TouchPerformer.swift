import MixboxFoundation

public protocol TouchPerformer: class {
    func touch(
        touchPaths: [[CGPoint]],
        duration: TimeInterval,
        isExpendable: Bool)
        throws
}
