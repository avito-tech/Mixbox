public protocol SnapshotsComparator {
    func equals(actual: UIImage, reference: UIImage) -> Bool
}
