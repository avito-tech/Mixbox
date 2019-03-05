import MixboxUiTestsFoundation

protocol PerformerOfSpecificImplementationOfInteractionForVisibleElement {
    func performInteractionForVisibleElement(
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        performingSpecificImplementationCanBeRepeated: Bool,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry,
        closureFailureMessage: String)
        -> InteractionResult
}
