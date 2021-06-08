public protocol NestedInteractionPerformer: AnyObject {
    func perform(interaction: ElementInteraction) -> InteractionResult
}
