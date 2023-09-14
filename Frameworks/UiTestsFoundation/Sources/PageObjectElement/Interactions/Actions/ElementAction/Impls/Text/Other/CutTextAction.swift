import MixboxFoundation
import MixboxIpcCommon

public final class CutTextAction: BaseElementInteractionWrapper {
    public init(
        interactionCoordinates: InteractionCoordinates)
    {
        super.init(
            wrappedInteraction: AndElementInteraction(
                descriptionBuilder: HumanReadableInteractionDescriptionBuilderImpl(
                    buildFunction: { info in
                        """
                        cut text from "\(info.elementName)"
                        """
                    }
                ),
                interactions: [
                    FocusKeyboardOnElementAction(
                        interactionCoordinates: interactionCoordinates
                    ),
                    OpenTextMenuAction(
                        interactionCoordinates: interactionCoordinates
                    ),
                    TextMenuAction(
                        possibleMenuTitles: TextMenuTitles.selectAll
                    ),
                    TextMenuAction(
                        possibleMenuTitles: TextMenuTitles.cut
                    )
                ]
            )
        )
    }
}
