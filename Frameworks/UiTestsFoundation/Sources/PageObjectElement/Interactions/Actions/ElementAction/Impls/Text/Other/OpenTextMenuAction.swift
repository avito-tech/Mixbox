import MixboxIpcCommon
import Foundation

public final class OpenTextMenuAction: BaseElementInteractionWrapper {
    public init(
        interactionCoordinates: InteractionCoordinates)
    {
        let longTapTimeToActivateMenu: TimeInterval = 1.5
        
        super.init(
            wrappedInteraction: WrappedDescriptionElementInteraction(
                interaction: PressAction(
                    duration: longTapTimeToActivateMenu,
                    interactionCoordinates: interactionCoordinates
                ),
                descriptionBuilder: { dependencies in
                    """
                    tap "\(dependencies.elementInfo.elementName)" and hold \(longTapTimeToActivateMenu) seconds, to open menu of actions
                    """
                }
            )
        )
    }
}
