public final class OpenTextMenuAction: BaseElementInteractionWrapper {
    public init(
        interactionCoordinates: InteractionCoordinates,
        minimalPercentageOfVisibleArea: CGFloat)
    {
        let longTapTimeToActivateMenu: TimeInterval = 1.5
        
        super.init(
            wrappedInteraction: WrappedDescriptionElementInteraction(
                interaction: PressAction(
                    duration: longTapTimeToActivateMenu,
                    interactionCoordinates: interactionCoordinates,
                    minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea
                ),
                descriptionBuilder: { dependencies in
                    """
                    тапнуть по "\(dependencies.elementInfo.elementName)" и удерживать \(longTapTimeToActivateMenu) секунд, чтобы открыть меню действий с текстом
                    """
                }
            )
        )
    }
}
