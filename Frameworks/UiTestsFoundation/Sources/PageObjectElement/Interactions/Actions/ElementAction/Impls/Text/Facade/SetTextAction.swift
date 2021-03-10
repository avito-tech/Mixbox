public final class SetTextAction: BaseElementInteractionWrapper {
    public init(
        descriptionBuilder: HumanReadableInteractionDescriptionBuilder,
        focusingAction: ElementInteraction?,
        actionOnFocusedElement: ElementInteraction)
    {
        super.init(
            wrappedInteraction: AndElementInteraction(
                descriptionBuilder: descriptionBuilder,
                interactions: [focusingAction, actionOnFocusedElement].compactMap { $0 }
            )
        )
    }
}
