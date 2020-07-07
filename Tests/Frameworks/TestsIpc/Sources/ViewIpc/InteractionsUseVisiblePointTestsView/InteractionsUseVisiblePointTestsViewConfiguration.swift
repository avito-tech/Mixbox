public final class InteractionsUseVisiblePointTestsViewConfiguration: Codable {
    public let buttonFrame: CGRect
    public let overlappingViewFrame: CGRect
    
    public init(
        buttonFrame: CGRect,
        overlappingViewFrame: CGRect)
    {
        self.buttonFrame = buttonFrame
        self.overlappingViewFrame = overlappingViewFrame
    }
}
