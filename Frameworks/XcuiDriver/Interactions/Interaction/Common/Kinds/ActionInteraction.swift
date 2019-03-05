import MixboxUiTestsFoundation
import MixboxTestsFoundation

final class ActionInteraction: Interaction {
    let description: InteractionDescription
    
    private let specificImplementation: InteractionSpecificImplementation
    private let interactionRetrier: InteractionRetrier
    private let performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement
    private let interactionFailureResultFactory: InteractionFailureResultFactory
    private let elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries
    
    // MARK: - State
    
    private var wasSuccessful = false
    
    init(
        settings: ResolvedInteractionSettings,
        specificImplementation: InteractionSpecificImplementation,
        interactionRetrier: InteractionRetrier,
        performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement,
        interactionFailureResultFactory: InteractionFailureResultFactory,
        elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries)
    {
        self.description = InteractionDescription(
            type: .action,
            settings: settings
        )
        self.specificImplementation = specificImplementation
        self.interactionRetrier = interactionRetrier
        self.performerOfSpecificImplementationOfInteractionForVisibleElement = performerOfSpecificImplementationOfInteractionForVisibleElement
        self.interactionFailureResultFactory = interactionFailureResultFactory
        self.elementResolverWithScrollingAndRetries = elementResolverWithScrollingAndRetries
    }
    
    func perform() -> InteractionResult {
        if wasSuccessful {
            return interactionFailureResultFactory.failureResult(
                resolvedElementQuery: nil,
                interactionSpecificFailure: nil,
                message: "Attempted to run successful action twice"
            )
        }
        
        return interactionRetrier.retryInteractionUntilTimeout { retriableTimedInteractionState in
            let resolvedElementQuery = elementResolverWithScrollingAndRetries.resolveElementWithRetries(
                isPossibleToRetryProvider: retriableTimedInteractionState
            )
            
            return performerOfSpecificImplementationOfInteractionForVisibleElement.performInteractionForVisibleElement(
                resolvedElementQuery: resolvedElementQuery,
                interactionSpecificImplementation: specificImplementation,
                performingSpecificImplementationCanBeRepeated: false,
                interactionMarkableAsImpossibleToRetry: retriableTimedInteractionState,
                closureFailureMessage: "пофейлилось само действие"
            )
        }
    }
}
