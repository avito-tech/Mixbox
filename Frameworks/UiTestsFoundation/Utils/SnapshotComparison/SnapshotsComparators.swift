public enum SnapshotsComparators: SnapshotsComparator {
    case perPixel
    case dHash(tolerance: Int)
    
    public func equals(actual: UIImage, reference: UIImage) -> Bool {
        return comparator.equals(actual: actual, reference: reference)
    }
    
    private var comparator: SnapshotsComparator {
        switch self {
        case .perPixel:
            return PerPixelSnapshotsComparator()
        case let .dHash(tolerance):
            return DHashSnapshotsComparator(tolerance: tolerance)
        }
    }
}
