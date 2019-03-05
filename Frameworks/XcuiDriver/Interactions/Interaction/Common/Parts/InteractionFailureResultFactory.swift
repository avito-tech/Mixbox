import MixboxUiTestsFoundation

protocol InteractionFailureResultFactory {
    func elementIsHiddenResult()
        -> InteractionResult
    
    func elementIsNotSufficientlyVisibleResult(
        percentageOfVisibleArea: CGFloat,
        minimalPercentageOfVisibleArea: CGFloat,
        scrollingFailureMessage: String?)
        -> InteractionResult
    
    func elementIsNotFoundResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    
    func elementIsNotUniqueResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    
    func failureResult(
        resolvedElementQuery: ResolvedElementQuery?,
        interactionSpecificFailure: InteractionSpecificFailure?,
        message: String)
        -> InteractionResult
}
