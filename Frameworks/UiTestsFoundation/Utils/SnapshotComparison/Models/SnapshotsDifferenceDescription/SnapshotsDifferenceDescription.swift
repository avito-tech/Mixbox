public protocol SnapshotsDifferenceDescription: class {
    var percentageOfMatching: Double { get }
    var message: String { get }
    var actualImage: UIImage { get }
    var expectedImage: UIImage { get }
}
