extension ImageHashCalculatorSnapshotsComparator {
    final class ComparisonError: Error {
        let snapshotsDifferenceDescription: SnapshotsDifferenceDescription
        
        init(snapshotsDifferenceDescription: SnapshotsDifferenceDescription) {
            self.snapshotsDifferenceDescription = snapshotsDifferenceDescription
        }
    }
}
