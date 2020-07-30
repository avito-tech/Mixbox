#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxIpcCommon

public final class VisibilityCheckerArguments {
    public let view: UIView
    
    // Pass this to get a point closest to given `InteractionCoordinates`
    public let interactionCoordinates: InteractionCoordinates?
    
    public let useHundredPercentAccuracy: Bool
    
    public init(
        view: UIView,
        interactionCoordinates: InteractionCoordinates?,
        useHundredPercentAccuracy: Bool)
    {
        self.view = view
        self.interactionCoordinates = interactionCoordinates
        self.useHundredPercentAccuracy = useHundredPercentAccuracy
    }
}

#endif
