import MixboxUiTestsFoundation
import MixboxTestsFoundation

// TODO: I think it doesn't wait if element is not visible. If element is not visible it should wait, because it
// can appear few moments later. So there is a possibility of false-positive check, which is a very bad thing.
final class InvisibilityCheckInteraction: Interaction {
    let description: InteractionDescription
    
    private let elementMatcher: ElementMatcher
    private let settings: ResolvedInteractionSettings
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementFinder: ElementFinder
    private let minimalPercentageOfVisibleArea: CGFloat
    private let interactionHelper: InteractionHelper
    
    init(
        settings: ResolvedInteractionSettings,
        elementFinder: ElementFinder,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        minimalPercentageOfVisibleArea: CGFloat,
        snapshotCaches: SnapshotCaches,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider)
    {
        self.settings = settings
        self.description = InteractionDescription(
            type: .check,
            settings: settings
        )
        self.elementMatcher = settings.elementSettings.matcher
        self.elementFinder = elementFinder
        self.elementVisibilityChecker = elementVisibilityChecker
        self.scrollingHintsProvider = scrollingHintsProvider
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        self.interactionHelper = InteractionHelper(
            messagePrefix: "Проверка не прошла",
            elementVisibilityChecker: elementVisibilityChecker,
            scrollingHintsProvider: scrollingHintsProvider,
            elementFinder: elementFinder,
            interactionSettings: description.settings,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            snapshotCaches: snapshotCaches,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider
        )
    }
    
    func perform() -> InteractionResult {
        return interactionHelper.retryInteractionUntilTimeout {
            var resolvedElementQuery = interactionHelper.resolveElementWithRetries()
            
            let failedElementsCountResult = checkForFailedElementsAndReturnCount(
                resolvedElementQuery: &resolvedElementQuery
            )
            
            switch failedElementsCountResult {
            case .failedElementsCount(let failedElementsCount):
                return makeInteractionResult(
                    failedElementsCount: failedElementsCount,
                    resolvedElementQuery: resolvedElementQuery
                )
            case .error(let message):
                return interactionHelper.failureResult(
                    message: message
                )
            }
        }
    }
    
    private enum CheckForFailedElementsAndReturnCountResult {
        case failedElementsCount(Int)
        case error(String)
    }
    
    private func checkForFailedElementsAndReturnCount(
        resolvedElementQuery: inout ResolvedElementQuery)
        -> CheckForFailedElementsAndReturnCountResult
    {
        var failedElementsCount = 0
        
        forEach: for var (index, snapshot) in resolvedElementQuery.matchingSnapshots.enumerated() {
            if snapshot.isDefinitelyHidden.value == true {
                // ok
            } else {
                let scrollingResult = interactionHelper.scrollIfNeeded(
                    snapshot: snapshot,
                    expectedIndexOfSnapshotInResolvedElementQuery: index,
                    resolvedElementQuery: resolvedElementQuery
                )
                
                snapshot = scrollingResult.updatedSnapshot
                resolvedElementQuery = scrollingResult.updatedResolvedElementQuery
                
                var alreadyCalculatedPercentageOfVisibleArea: CGFloat?
                
                switch scrollingResult.status {
                case .scrolled:
                    // Ok
                    break
                case .alreadyVisible(let percentageOfVisibleArea):
                    alreadyCalculatedPercentageOfVisibleArea = percentageOfVisibleArea
                case .elementWasLostAfterScroll:
                    // Ok
                    break forEach
                case .internalError:
                    // Before:
                    // return .error(message)
                    // After:
                    break
                    
                    // TODO: Investigate the problem:
                    //
                    // We had an error in testcase 23999:
                    // - isNotDisplayed check was used
                    // - the scrolling hints provider couldn't not provide hint
                    // - element was not visible
                    //
                    // So it should be a normal situation. We should not fail test if we can't scroll to something invisible.
                    //
                    // Scrolling hints provider returned `.canNotProvideHintForCurrentRequest`, then it was converted to `.internalError`
                    // and led to test failure. The name may be misleading. There might be problems somewhere near
                    // that code.
                }
                
                let percentageOfVisibleArea = alreadyCalculatedPercentageOfVisibleArea
                    ?? elementVisibilityChecker.percentageOfVisibleArea(snapshot: snapshot)
                
                if percentageOfVisibleArea >= minimalPercentageOfVisibleArea {
                    failedElementsCount += 1
                }
            }
        }
        
        return .failedElementsCount(failedElementsCount)
    }
    
    func makeInteractionResult(
        failedElementsCount: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    {
        if failedElementsCount > 0 {
            let message: String
            
            if failedElementsCount == 1 && resolvedElementQuery.matchingSnapshots.count == 1 {
                message = "элемент является видимым"
            } else {
                let totalCount = resolvedElementQuery.matchingSnapshots.count
                message = "\(failedElementsCount) из \(totalCount) подходящих элементов являются видимыми"
            }
            
            return interactionHelper.failureResult(
                resolvedElementQuery: resolvedElementQuery,
                message: message
            )
        } else {
            return .success
        }
    }
}
