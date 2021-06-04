public final class SnapshotsComparatorFactoryImpl: SnapshotsComparatorFactory {
    public init() {
    }
    
    public func snapshotsComparator(type: SnapshotsComparatorType) -> SnapshotsComparator {
        switch type {
        case .perPixel:
            return PerPixelSnapshotsComparator(
                tolerance: 0,
                forceUsingNonDiscretePercentageOfMatching: false
            )
        case let .dHash(tolerance):
            return ImageHashCalculatorSnapshotsComparator(
                imageHashCalculator: DHashImageHashCalculator(),
                hashDistanceTolerance: tolerance,
                shouldIgnoreTransparency: true
            )
        }
    }
}
