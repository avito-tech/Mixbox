#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import Foundation

public final class ViewVisibilityCheckerResult {
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

#endif
