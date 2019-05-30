public protocol InteractionRetrier: class {
    func retryInteractionUntilTimeout(
        closure: (_ interaction: RetriableTimedInteractionState) -> InteractionResult)
        -> InteractionResult
}
