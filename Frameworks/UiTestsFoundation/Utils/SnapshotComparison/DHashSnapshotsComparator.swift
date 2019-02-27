public final class DHashSnapshotsComparator: SnapshotsComparator {
    private let tolerance: Int
    
    public init(tolerance: Int = 15) {
        self.tolerance = tolerance
    }
    
    public func equals(actual: UIImage, reference: UIImage) -> Bool {
        return DHashV0ImageHashCalculator().hashDistance(
            lhs: actual,
            rhs: reference
        ) <= tolerance
    }
}
