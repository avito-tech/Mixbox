// TODO: `public protocol SnapshotsComparator: class`
public protocol SnapshotsComparator {
    func equals(actual: UIImage, expected: UIImage) -> MatchingResult
}
