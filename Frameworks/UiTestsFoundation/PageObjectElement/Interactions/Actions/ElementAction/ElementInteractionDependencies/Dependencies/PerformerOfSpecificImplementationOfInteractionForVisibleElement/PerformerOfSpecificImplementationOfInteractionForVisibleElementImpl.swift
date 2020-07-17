import MixboxIpcCommon

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
        overridenPercentageOfVisibleArea: CGFloat?,
        interactionCoordinates: InteractionCoordinates?,
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        interactionMarkableAsImpossibleToRetry: MarkableAsImpossibleToRetry)
        -> InteractionResult
    {
        let minimalPercentageOfVisibleArea = overridenPercentageOfVisibleArea
            ?? elementSettings.percentageOfVisibleArea
        
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
            
            var potentialCauseOfFailure: String?
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
                potentialCauseOfFailure = "ошибка при автоскролле - элемент пропал из иерархии после скролла"
            case .error(let message):
                potentialCauseOfFailure = message
            }
            
            do {
                let visibilityCheckResult: ElementVisibilityCheckerResult
                
                if let alreadyCalculatedPercentageOfVisibleArea = alreadyCalculatedPercentageOfVisibleArea, interactionCoordinates == nil {
                    visibilityCheckResult = ElementVisibilityCheckerResult(
                        percentageOfVisibleArea: alreadyCalculatedPercentageOfVisibleArea,
                        visibilePointOnScreenClosestToInteractionCoordinates: nil
                    )
                } else {
                    visibilityCheckResult = try elementVisibilityChecker.checkVisibility(
                        snapshot: snapshot,
                        interactionCoordinates: interactionCoordinates
                    )
                }
                
                let percentageOfVisibleArea = visibilityCheckResult.percentageOfVisibleArea
                
                let elementIsSufficientlyVisible = percentageOfVisibleArea >= minimalPercentageOfVisibleArea
                
                if elementIsSufficientlyVisible {
                    let result = interactionSpecificImplementation.perform(
                        resolverResult: SnapshotForInteractionResolverResult(
                            visiblePoint: visibilityCheckResult.visibilePointOnScreenClosestToInteractionCoordinates,
                            elementSnapshot: snapshot
                        )
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
                        potentialCauseOfFailure: potentialCauseOfFailure
                    )
                }
            } catch {
                return interactionFailureResultFactory.elementIsNotSufficientlyVisibleResult(
                    percentageOfVisibleArea: 0,
                    minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
                    potentialCauseOfFailure: "\(error)"
                )
            }
        } else {
            return interactionFailureResultFactory.elementIsNotFoundResult()
        }
    }
}
