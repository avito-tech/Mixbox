import MixboxFoundation

public protocol ElementInteractionPerformer: class {
    func perform(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
}
