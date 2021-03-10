// Note: comparators compare for similarity, not for equality.
// For some comparators similarity can mean equality.
public enum SnapshotsComparisonResult {
    case similar
    case different(SnapshotsDifferenceDescription)
}
