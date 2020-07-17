#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpc

public final class CheckVisibilityIpcMethod: IpcMethod {
    public final class _Arguments: Codable {
        public let elementUniqueIdentifier: String
        public let interactionCoordinates: InteractionCoordinates?
        
        public init(
            elementUniqueIdentifier: String,
            interactionCoordinates: InteractionCoordinates?)
        {
            self.elementUniqueIdentifier = elementUniqueIdentifier
            self.interactionCoordinates = interactionCoordinates
        }
    }
    
    public final class Result: Codable {
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
    
    public typealias Arguments = _Arguments
    public typealias ReturnValue = IpcThrowingFunctionResult<Result>
    
    public init() {
    }
}

#endif
