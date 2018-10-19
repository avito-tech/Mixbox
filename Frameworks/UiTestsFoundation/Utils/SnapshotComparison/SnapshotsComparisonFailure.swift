public final class SnapshotsComparisonFailure {
    public let message: String
    public let expectedImage: UIImage?
    public let actualImage: UIImage?
    public let differenceImage: UIImage?
    
    public init(
        message: String,
        expectedImage: UIImage?,
        actualImage: UIImage?,
        differenceImage: UIImage?)
    {
        self.message = message
        self.expectedImage = expectedImage
        self.actualImage = actualImage
        self.differenceImage = differenceImage
    }
}
