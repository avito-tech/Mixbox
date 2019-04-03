import MixboxFoundation

public final class CutTextAction: BaseElementInteractionWrapper {
    public init(
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        super.init(
            wrappedInteraction: AndElementInteraction(
                descriptionBuilder: HumanReadableInteractionDescriptionBuilderImpl(
                    buildFunction: { info in
                        "вырезать текст из '\(info.elementName)'"
                    }
                ),
                interactions: [
                    FocusKeyboardOnElementAction(
                        interactionCoordinates: interactionCoordinates,
                        minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
                    ),
                    OpenTextMenuAction(
                        interactionCoordinates: interactionCoordinates,
                        minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
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
