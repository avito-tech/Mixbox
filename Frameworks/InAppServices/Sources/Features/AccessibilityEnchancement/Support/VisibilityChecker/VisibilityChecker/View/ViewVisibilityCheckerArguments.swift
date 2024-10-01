#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import UIKit
import MixboxIpcCommon

public final class ViewVisibilityCheckerArguments {
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
