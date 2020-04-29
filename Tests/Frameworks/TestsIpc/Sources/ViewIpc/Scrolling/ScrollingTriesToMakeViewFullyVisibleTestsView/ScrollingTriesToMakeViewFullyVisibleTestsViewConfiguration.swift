public final class ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration: Codable {
    public let buttonFrame: CGRect
    public let contentSize: CGSize
    public let overlappingViewSize: CGSize
    
    public init(
        buttonFrame: CGRect,
        contentSize: CGSize,
        overlappingViewSize: CGSize)
    {
        self.buttonFrame = buttonFrame
        self.contentSize = contentSize
        self.overlappingViewSize = overlappingViewSize
    }
}
