public final class PerPixelSnapshotsComparator: SnapshotsComparator {
    public init() {
    }
    
    public func equals(actual: UIImage, reference: UIImage) -> Bool {
        return actual.perPixelEquals(to: reference)
    }
}
