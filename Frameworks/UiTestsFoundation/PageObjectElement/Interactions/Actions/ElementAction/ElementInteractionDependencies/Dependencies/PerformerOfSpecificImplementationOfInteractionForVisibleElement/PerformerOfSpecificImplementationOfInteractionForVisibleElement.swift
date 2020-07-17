import MixboxIpcCommon

public protocol PerformerOfSpecificImplementationOfInteractionForVisibleElement: class {
    func performInteractionForVisibleElement(
        overridenPercentageOfVisibleArea: CGFloat?,
        interactionCoordinates: InteractionCoordinates?,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
}
