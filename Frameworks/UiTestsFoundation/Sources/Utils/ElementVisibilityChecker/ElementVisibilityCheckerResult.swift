import UIKit

public final class ElementVisibilityCheckerResult: Codable {
    // `percentageOfVisibleArea` for view with specified `elementUniqueIdentifier`
    public let percentageOfVisibleArea: CGFloat
    
    // Guaranteed to be not nil if `interactionCoordinates` are passed.
    public let visibilePointOnScreenClosestToInteractionCoordinates: CGPoint?
    
    public init(
        percentageOfVisibleArea: CGFloat,
        visibilePointOnScreenClosestToInteractionCoordinates: CGPoint?)
    {
        self.percentageOfVisibleArea = percentageOfVisibleArea
        self.visibilePointOnScreenClosestToInteractionCoordinates = visibilePointOnScreenClosestToInteractionCoordinates
    }
}
