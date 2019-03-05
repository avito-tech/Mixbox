import MixboxUiTestsFoundation

protocol InteractionRetrier {
    func retryInteractionUntilTimeout(
        closure: (_ interaction: RetriableTimedInteractionState) -> InteractionResult)
        -> InteractionResult
}
