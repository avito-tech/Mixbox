public protocol SnapshotsComparator: class {
    func compare(actualImage: UIImage, expectedImage: UIImage) -> SnapshotsComparisonResult
}
