import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class VisibleElementCheckInteraction: Interaction {
    let description: InteractionDescription
    
    private let specificImplementation: InteractionSpecificImplementation
    private let interactionRetrier: InteractionRetrier
    private let performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement
    private let interactionFailureResultFactory: InteractionFailureResultFactory
    private let elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries
    
    init(
        settings: ResolvedInteractionSettings,
        specificImplementation: InteractionSpecificImplementation,
        interactionRetrier: InteractionRetrier,
        performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement,
        interactionFailureResultFactory: InteractionFailureResultFactory,
        elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries)
    {
        self.description = InteractionDescription(
            type: .check,
            settings: settings
        )
        self.specificImplementation = specificImplementation
        self.interactionRetrier = interactionRetrier
        self.performerOfSpecificImplementationOfInteractionForVisibleElement = performerOfSpecificImplementationOfInteractionForVisibleElement
        self.interactionFailureResultFactory = interactionFailureResultFactory
        self.elementResolverWithScrollingAndRetries = elementResolverWithScrollingAndRetries
    }
    
    func perform() -> InteractionResult {
        return interactionRetrier.retryInteractionUntilTimeout { retriableTimedInteractionState in
            let resolvedElementQuery = elementResolverWithScrollingAndRetries.resolveElementWithRetries(
                isPossibleToRetryProvider: retriableTimedInteractionState
            )
            
            return performerOfSpecificImplementationOfInteractionForVisibleElement.performInteractionForVisibleElement(
                resolvedElementQuery: resolvedElementQuery,
                interactionSpecificImplementation: specificImplementation,
                performingSpecificImplementationCanBeRepeated: true,
                interactionMarkableAsImpossibleToRetry: retriableTimedInteractionState,
                closureFailureMessage: "пофейлилась сама проверка"
            )
        }
    }
}
