public final class SnapshotsComparatorFactoryImpl: SnapshotsComparatorFactory {
    public init() {
    }
    
    public func snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator {
        switch type {
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
