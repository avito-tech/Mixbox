public protocol PerformerOfSpecificImplementationOfInteractionForVisibleElement: class {
    func performInteractionForVisibleElement(
        minimalPercentageOfVisibleArea: CGFloat,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
}
