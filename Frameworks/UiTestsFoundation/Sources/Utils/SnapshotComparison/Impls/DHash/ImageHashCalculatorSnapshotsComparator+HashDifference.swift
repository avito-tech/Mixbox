extension ImageHashCalculatorSnapshotsComparator {
    final class HashDifference {
        let distance: UInt8
        let actualHash: UInt64
        let expectedHash: UInt64
        
        init(
            distance: UInt8,
            actualHash: UInt64,
            expectedHash: UInt64)
        {
            self.distance = distance
            self.actualHash = actualHash
            self.expectedHash = expectedHash
        }
    }
}
