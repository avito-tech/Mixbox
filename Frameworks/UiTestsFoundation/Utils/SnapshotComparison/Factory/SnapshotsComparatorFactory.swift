public protocol SnapshotsComparatorFactory {
    func snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator
}
