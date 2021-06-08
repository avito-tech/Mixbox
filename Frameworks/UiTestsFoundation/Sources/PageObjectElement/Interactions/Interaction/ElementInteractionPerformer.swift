import MixboxFoundation

public protocol ElementInteractionPerformer: AnyObject {
    func perform(
        interaction: ElementInteraction,
        interactionPerformingSettings: InteractionPerformingSettings)
        -> InteractionResult
}
