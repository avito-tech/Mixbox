import MixboxFoundation

public protocol TouchPerformer: AnyObject {
    func touch(
        touchPaths: [[CGPoint]],
        duration: TimeInterval,
        isExpendable: Bool)
        throws
}
