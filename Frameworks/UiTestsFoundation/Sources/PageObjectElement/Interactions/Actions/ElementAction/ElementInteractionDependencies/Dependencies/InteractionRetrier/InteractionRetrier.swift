public protocol InteractionRetrier: AnyObject {
    func retryInteractionUntilTimeout(
        closure: (_ interaction: RetriableTimedInteractionState) -> InteractionResult)
        -> InteractionResult
}
