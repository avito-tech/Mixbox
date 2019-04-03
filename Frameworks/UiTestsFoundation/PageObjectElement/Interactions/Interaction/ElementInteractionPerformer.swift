import MixboxFoundation

public protocol ElementInteractionPerformer {
    func perform(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
}
