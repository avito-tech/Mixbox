public final class PerPixelSnapshotsComparator: SnapshotsComparator {
    public init() {
    }
    
    public func equals(actual: UIImage, expected: UIImage) -> MatchingResult {
        if actual.perPixelEquals(to: expected) {
            return .match
        } else {
            return .exactMismatch(mismatchDescription: { "image has different pixels" })
        }
    }
}
