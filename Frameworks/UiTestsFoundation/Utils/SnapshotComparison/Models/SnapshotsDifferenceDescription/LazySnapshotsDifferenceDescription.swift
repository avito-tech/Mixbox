public final class LazySnapshotsDifferenceDescription: SnapshotsDifferenceDescription {
    public let percentageOfMatching: Double
    public private(set) lazy var message: String = messageFactory()
    public let actualImage: UIImage
    public let expectedImage: UIImage
    
    private let messageFactory: () -> String
    
    public init(
        percentageOfMatching: Double,
        messageFactory: @escaping () -> String,
        actualImage: UIImage,
        expectedImage: UIImage)
    {
        self.percentageOfMatching = percentageOfMatching
        self.messageFactory = messageFactory
        self.actualImage = actualImage
        self.expectedImage = expectedImage
    }
}
