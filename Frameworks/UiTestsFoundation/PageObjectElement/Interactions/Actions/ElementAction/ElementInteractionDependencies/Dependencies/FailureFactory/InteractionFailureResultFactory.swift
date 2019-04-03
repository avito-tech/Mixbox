import MixboxUiTestsFoundation

public protocol InteractionFailureResultFactory {
    func elementIsHiddenResult()
        -> InteractionResult
    
    func elementIsNotSufficientlyVisibleResult(
        percentageOfVisibleArea: CGFloat,
        minimalPercentageOfVisibleArea: CGFloat,
        scrollingFailureMessage: String?)
        -> InteractionResult
    
    func elementIsNotFoundResult()
        -> InteractionResult
    
    func elementIsNotUniqueResult()
        -> InteractionResult
    
    func failureResult(
        message: String)
        -> InteractionResult
    
    func failureResult(
        interactionFailure: InteractionFailure)
        -> InteractionResult
}

extension InteractionFailureResultFactory {
    public func failureResult(
        message: String)
        -> InteractionResult
    {
        return failureResult(
            interactionFailure: InteractionFailure(message: message, attachments: [], nestedFailures: [])
        )
    }
}
