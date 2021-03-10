public protocol NestedInteractionPerformer: class {
    func perform(interaction: ElementInteraction) -> InteractionResult
}
