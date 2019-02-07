import MixboxUiTestsFoundation

// To make code compile. Will be implemented later.
final class NotImplementedInteractionFactory: InteractionFactory {
    func actionInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        preconditionFailure("Not implemented")
    }
    
    func checkForNotDisplayedInteraction(
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        preconditionFailure("Not implemented")
    }
    
    func checkInteraction(
        specificImplementation: InteractionSpecificImplementation,
        settings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat)
        -> Interaction
    {
        preconditionFailure("Not implemented")
    }
}
