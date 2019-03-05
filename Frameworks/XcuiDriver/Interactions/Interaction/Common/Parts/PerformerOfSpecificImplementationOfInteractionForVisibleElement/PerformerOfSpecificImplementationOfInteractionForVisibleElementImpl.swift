import MixboxUiTestsFoundation

final class PerformerOfSpecificImplementationOfInteractionForVisibleElementImpl: PerformerOfSpecificImplementationOfInteractionForVisibleElement {
    
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let elementSettings: ElementSettings
    private let minimalPercentageOfVisibleArea: CGFloat
    private let interactionFailureResultFactory: InteractionFailureResultFactory
    private let scroller: Scroller
    
    init(
        elementVisibilityChecker: ElementVisibilityChecker,
        elementSettings: ElementSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        interactionFailureResultFactory: InteractionFailureResultFactory,
        scroller: Scroller)
    {
        self.elementVisibilityChecker = elementVisibilityChecker
        self.elementSettings = elementSettings
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.interactionFailureResultFactory = interactionFailureResultFactory
        self.scroller = scroller
    }

    func performInteractionForVisibleElement(
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        performingSpecificImplementationCanBeRepeated: Bool,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry,
        closureFailureMessage: String)
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
                    return interactionFailureResultFactory.elementIsNotUniqueResult(
                        resolvedElementQuery: resolvedElementQuery
                    )
                }
            case .useElementAtIndexInHierarchy:
                break
            }
            
            if snapshot.isDefinitelyHidden.value == true {
                return interactionFailureResultFactory.elementIsHiddenResult()
            }
            
            let scrollingResult = scroller.scrollIfNeeded(
                snapshot: snapshot,
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
            case .internalError(let message):
                scrollingFailureMessage = message
            }
            
            let percentageOfVisibleArea = alreadyCalculatedPercentageOfVisibleArea
                ?? elementVisibilityChecker.percentageOfVisibleArea(snapshot: snapshot)
            
            let elementIsSufficientlyVisible = percentageOfVisibleArea >= minimalPercentageOfVisibleArea
            
            if elementIsSufficientlyVisible {
                let result = interactionSpecificImplementation.perform(
                    snapshot: snapshot
                )
                
                if !performingSpecificImplementationCanBeRepeated {
                    interactionMarkableAsImpossibleToRetry.markAsImpossibleToRetry()
                }
                
                switch result {
                case .success:
                    return .success
                case .failure(let interactionSpecificFailure):
                    return interactionFailureResultFactory.failureResult(
                        resolvedElementQuery: nil,
                        interactionSpecificFailure: interactionSpecificFailure,
                        message: "\(closureFailureMessage): \(interactionSpecificFailure.message)"
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
            return interactionFailureResultFactory.elementIsNotFoundResult(
                resolvedElementQuery: resolvedElementQuery
            )
        }
    }
}
