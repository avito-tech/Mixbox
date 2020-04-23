public final class PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl:
    PerformerOfSpecificImplementationOfInteractionForVisibleElement
{
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let elementSettings: ElementSettings
    private let interactionFailureResultFactory: InteractionFailureResultFactory
    private let scroller: Scroller
    
    public init(
        elementVisibilityChecker: ElementVisibilityChecker,
        elementSettings: ElementSettings,
        interactionFailureResultFactory: InteractionFailureResultFactory,
        scroller: Scroller)
    {
        self.elementVisibilityChecker = elementVisibilityChecker
        self.elementSettings = elementSettings
        self.interactionFailureResultFactory = interactionFailureResultFactory
        self.scroller = scroller
    }

    // TODO: Split function
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func performInteractionForVisibleElement(
        minimalPercentageOfVisibleArea: CGFloat,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
    {
        var resolvedElementQuery = resolvedElementQuery
        let expectedIndexOfSnapshot: Int
        
        switch elementSettings.interactionMode {
        case .useUniqueElement:
            expectedIndexOfSnapshot = 0
        case .useElementAtIndexInHierarchy(let index):
            expectedIndexOfSnapshot = index
        }
        
        if var snapshot = resolvedElementQuery.matchingSnapshots.mb_elementAtIndex(expectedIndexOfSnapshot) {
            switch elementSettings.interactionMode {
            case .useUniqueElement:
                if resolvedElementQuery.matchingSnapshots.count > 1 {
                    return interactionFailureResultFactory.elementIsNotUniqueResult()
                }
            case .useElementAtIndexInHierarchy:
                break
            }
            
            if snapshot.isDefinitelyHidden.valueIfAvailable == true {
                return interactionFailureResultFactory.elementIsHiddenResult()
            }
            
            let scrollingResult = scroller.scrollIfNeeded(
                snapshot: snapshot,
                minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                expectedIndexOfSnapshotInResolvedElementQuery: expectedIndexOfSnapshot,
                resolvedElementQuery: resolvedElementQuery
            )
            
            var scrollingFailureMessage: String?
            var alreadyCalculatedPercentageOfVisibleArea: CGFloat?
            
            snapshot = scrollingResult.updatedSnapshot
            resolvedElementQuery = scrollingResult.updatedResolvedElementQuery
            
            switch scrollingResult.status {
            case .scrolled:
                // Ok
                break
            case .alreadyVisible(let percentageOfVisibleArea):
                alreadyCalculatedPercentageOfVisibleArea = percentageOfVisibleArea
            case .elementWasLostAfterScroll:
                scrollingFailureMessage = "ошибка при автоскролле - элемент пропал из иерархии после скролла"
            case .error(let message):
                scrollingFailureMessage = message
            }
            
            let percentageOfVisibleArea = alreadyCalculatedPercentageOfVisibleArea
                ?? elementVisibilityChecker.percentageOfVisibleArea(snapshot: snapshot)
            
            let elementIsSufficientlyVisible = percentageOfVisibleArea >= minimalPercentageOfVisibleArea
            
            if elementIsSufficientlyVisible {
                let result = interactionSpecificImplementation.perform(
                    snapshot: snapshot
                )
                
                switch result {
                case .success:
                    return .success
                case .failure(let interactionFailure):
                    return interactionFailureResultFactory.failureResult(
                        interactionFailure: interactionFailure
                    )
                }
            } else {
                return interactionFailureResultFactory.elementIsNotSufficientlyVisibleResult(
                    percentageOfVisibleArea: percentageOfVisibleArea,
                    minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                    scrollingFailureMessage: scrollingFailureMessage
                )
            }
        } else {
            return interactionFailureResultFactory.elementIsNotFoundResult()
        }
    }
}
