public protocol PerformerOfSpecificImplementationOfInteractionForVisibleElement {
    func performInteractionForVisibleElement(
        minimalPercentageOfVisibleArea: CGFloat,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
}
