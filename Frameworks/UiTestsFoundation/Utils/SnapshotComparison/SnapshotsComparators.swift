public enum SnapshotsComparators: SnapshotsComparator {
    case perPixel
    case dHash(tolerance: UInt8)
    
    public func equals(actual: UIImage, expected: UIImage) -> MatchingResult {
        return comparator.equals(actual: actual, expected: expected)
    }
    
    private var comparator: SnapshotsComparator {
        switch self {
        case .perPixel:
            return PerPixelSnapshotsComparator()
        case let .dHash(tolerance):
            return ImageHashCalculatorSnapshotsComparator(
                imageHashCalculator: DHashV0ImageHashCalculator(),
                hashDistanceTolerance: tolerance
            )
        }
    }
}
