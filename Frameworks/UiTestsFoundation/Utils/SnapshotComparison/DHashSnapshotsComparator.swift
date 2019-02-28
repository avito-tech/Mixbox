public final class DHashSnapshotsComparator: SnapshotsComparator {
    private let calculator = DHashV0ImageHashCalculator()
    private let tolerance: Int
    
    public init(tolerance: Int = 15) {
        self.tolerance = tolerance
    }
    
    public func equals(actual: UIImage, reference: UIImage) -> Bool {
        let hashDistance = calculator.hashDistance(
            lhsHash: calculator.imageHash(image: actual),
            rhsHash: calculator.imageHash(image: reference)
        )
        return hashDistance <= tolerance
    }
}
