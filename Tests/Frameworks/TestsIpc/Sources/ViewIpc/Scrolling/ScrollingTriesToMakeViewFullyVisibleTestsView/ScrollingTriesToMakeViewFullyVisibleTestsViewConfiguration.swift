import UIKit

public final class ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration: Codable {
    public let buttonFrame: CGRect
    public let contentSize: CGSize
    public let overlappingViewFrame: CGRect
    
    public init(
        buttonFrame: CGRect,
        contentSize: CGSize,
        overlappingViewFrame: CGRect)
    {
        self.buttonFrame = buttonFrame
        self.contentSize = contentSize
        self.overlappingViewFrame = overlappingViewFrame
    }
}
