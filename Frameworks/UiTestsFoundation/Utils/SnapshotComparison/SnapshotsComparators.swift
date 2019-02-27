public enum SnapshotsComparators: SnapshotsComparator {
    case perPixel
    case dHash
    
    public func equals(actual: UIImage, reference: UIImage) -> Bool {
        return comparator.equals(actual: actual, reference: reference)
    }
    
    private var comparator: SnapshotsComparator {
        switch self {
        case .perPixel:
            return PerPixelSnapshotsComparator()
        case .dHash:
            return DHashSnapshotsComparator()
        }
    }
}
