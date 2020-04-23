import  MixboxFoundation

public final class SnapshotForInteractionResolverImpl: SnapshotForInteractionResolver {
    private let retriableTimedInteractionState: RetriableTimedInteractionState
    private let interactionRetrier: InteractionRetrier
    private let performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement
    private let interactionFailureResultFactory: InteractionFailureResultFactory
    private let elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries
    
    public init(
        retriableTimedInteractionState: RetriableTimedInteractionState,
        interactionRetrier: InteractionRetrier,
        performerOfSpecificImplementationOfInteractionForVisibleElement: PerformerOfSpecificImplementationOfInteractionForVisibleElement,
        interactionFailureResultFactory: InteractionFailureResultFactory,
        elementResolverWithScrollingAndRetries: ElementResolverWithScrollingAndRetries)
    {
        self.retriableTimedInteractionState = retriableTimedInteractionState
        self.interactionRetrier = interactionRetrier
        self.performerOfSpecificImplementationOfInteractionForVisibleElement = performerOfSpecificImplementationOfInteractionForVisibleElement
        self.interactionFailureResultFactory = interactionFailureResultFactory
        self.elementResolverWithScrollingAndRetries = elementResolverWithScrollingAndRetries
    }
    
    public func resolve(
        minimalPercentageOfVisibleArea: CGFloat,
        completion: @escaping (ElementSnapshot) -> (InteractionResult))
        throws
        -> InteractionResult
    {
        let resolvedElementQuery = try elementResolverWithScrollingAndRetries.resolveElementWithRetries(
            isPossibleToRetryProvider: retriableTimedInteractionState
        )
        
        return performerOfSpecificImplementationOfInteractionForVisibleElement.performInteractionForVisibleElement(
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            resolvedElementQuery: resolvedElementQuery,
            interactionSpecificImplementation: InteractionSpecificImplementation {
                completion($0)
            },
            interactionMarkableAsImpossibleToRetry: retriableTimedInteractionState
        )
    }
}
