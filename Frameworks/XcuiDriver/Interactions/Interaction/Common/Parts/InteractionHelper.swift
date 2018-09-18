import MixboxUiTestsFoundation
import XCTest

// TODO: We must split this in parts.
final class InteractionHelper {
    private let messagePrefix: String
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let elementSettings: ElementSettings
    private let interactionName: String
    private let minimalPercentageOfVisibleArea: CGFloat
    private let searchTimeout: TimeInterval
    private let scroller: Scroller
    private let elementResolver: ElementResolver
    private let pollingConfiguration: PollingConfiguration
    private let snapshotCaches: SnapshotCaches
    
    // State:
    private var startDateOfInteraction = Date()
    private var retryingIsPossible = true
    
    init(
        messagePrefix: String,
        elementVisibilityChecker: ElementVisibilityChecker,
        scrollingHintsProvider: ScrollingHintsProvider,
        elementFinder: ElementFinder,
        interactionSettings: ResolvedInteractionSettings,
        minimalPercentageOfVisibleArea: CGFloat,
        snapshotCaches: SnapshotCaches)
    {
        self.messagePrefix = messagePrefix
        self.elementVisibilityChecker = elementVisibilityChecker
        self.elementSettings = interactionSettings.elementSettings
        self.elementResolver = ElementResolverImpl(
            elementFinder: elementFinder,
            elementSettings: elementSettings
        )
        self.scroller = Scroller(
            scrollingHintsProvider: scrollingHintsProvider,
            elementVisibilityChecker: elementVisibilityChecker,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            elementResolver: elementResolver
        )
        
        self.interactionName = interactionSettings.interactionName
        self.minimalPercentageOfVisibleArea = minimalPercentageOfVisibleArea
        
        let defaultTimeout: TimeInterval = 15
        self.searchTimeout = interactionSettings.elementSettings.searchTimeout ?? defaultTimeout
        self.pollingConfiguration = interactionSettings.pollingConfiguration
        self.snapshotCaches = snapshotCaches
    }
    
    func retryInteractionUntilTimeout(closure: () -> InteractionResult) -> InteractionResult {
        startDateOfInteraction = Date()
        
        var result = closure()
        
        while retryingIsPossible, !interactionWasTimedOut(), case .failure = result {
            XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
            
            respectPollingConfiguration()
            result = closure()
        }
        
        return result
    }
    
    func resolveElement() -> ResolvedElementQuery {
        return elementResolver.resolveElement()
    }
    
    func resolveElementWithRetries() -> ResolvedElementQuery {
        var resolvedElementQuery = resolveElement()
        
        resolvedElementQuery = reresolveElementWithRetriesIfNeeded(
            resolvedElementQuery: resolvedElementQuery
        )
        resolvedElementQuery = reresolveElementWithScrollingIfNeeded(
            resolvedElementQuery: resolvedElementQuery
        )
        
        return resolvedElementQuery
    }
    
    private func reresolveElementWithRetriesIfNeeded(
        resolvedElementQuery: ResolvedElementQuery)
        -> ResolvedElementQuery
    {
        // Note that if `searchTimeout == 0` nothing will happen.
        
        var resolvedElementQuery = resolvedElementQuery
        
        while shouldRetryResolvingElement(resolvedElementQuery: resolvedElementQuery)
            && !interactionWasTimedOut()
        {
            XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
            respectPollingConfiguration()
            resolvedElementQuery = resolveElement()
        }
        
        return resolvedElementQuery
    }
    
    private func interactionWasTimedOut() -> Bool {
        return  Date().timeIntervalSince(startDateOfInteraction) > searchTimeout
    }
    
    private func shouldRetryResolvingElement(resolvedElementQuery: ResolvedElementQuery) -> Bool {
        // Element may be not found if it just didn't appear if something is not fully loaded. A normal situation.
        let elementIsFound = resolvedElementQuery.matchingSnapshots.count > 0
        
        // Element may be not unique withing the animation in Collection View.
        // Because Collection View duplicate cells during animation.
        // So we will wait for a while. For example, cell that is used for animation will be hidden after
        // an animation and it will be filtered out.
        let elementIsUnique: Bool
        
        switch elementSettings.interactionMode {
        case .useUniqueElement:
            elementIsUnique = resolvedElementQuery.matchingSnapshots.count == 1
        case .useElementAtIndexInHierarchy:
            elementIsUnique = true
        }
        
        return !elementIsFound || !elementIsUnique
    }
    
    private func reresolveElementWithScrollingIfNeeded(
        resolvedElementQuery: ResolvedElementQuery)
        -> ResolvedElementQuery
    {
        // TODO: Improve the code. This is placed here like a kludge.
        
        var resolvedElementQuery = resolvedElementQuery
        
        var needToScroll: Bool {
            return resolvedElementQuery.matchingSnapshots.isEmpty
        }
        
        if elementSettings.searchMode == .scrollBlindly && elementSettings.searchMode != .useCurrentlyVisible {
            XcElementSnapshotCacheSyncronizationImpl.instance.dropCaches()
            
            let scrollingDistance = 8
            
            for _ in 0..<scrollingDistance where needToScroll {
                gentlyScroll(up: true)
                resolvedElementQuery = resolveElement()
            }
            
            // We must scroll and scroll back twice as much to cover a certain radius (== scrollingDistance):
            // ---------------------------------------------
            //                               . <- enough
            //                              .
            // .   . <- not enough     .   .
            //  . .                     . .
            //   .                       .
            // ---------------------------------------------
            
            for _ in 0..<(scrollingDistance * 2) where needToScroll {
                gentlyScroll(up: false)
                resolvedElementQuery = resolveElement()
            }
        }
        
        return resolvedElementQuery
    }
    
    private func gentlyScroll(up: Bool) {
        let application = XCUIApplication()
        let frame = ApplicationFrameProvider.frame
        
        snapshotCaches.application.use {
            application.center.press(
                forDuration: 0,
                thenDragTo: application.tappableCoordinate(
                    x: frame.mb_centerX,
                    y: up ? 0 : frame.height
                )
            )
        }
    }
    
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
    {
        // TODO: Better code. These lines just disable scrolling with minimal number of lines and minimal consequences.
        // (at the moment the code was written, we all know what can happen with code if it will live for long)
        if elementSettings.searchMode == .useCurrentlyVisible {
            return ScrollingResult(
                status: .scrolled, // this is a lie, but without consequences
                updatedSnapshot: snapshot,
                updatedResolvedElementQuery: resolvedElementQuery
            )
        }
        
        return scroller.scrollIfNeeded(
            snapshot: snapshot,
            expectedIndexOfSnapshotInResolvedElementQuery: expectedIndexOfSnapshotInResolvedElementQuery,
            resolvedElementQuery: resolvedElementQuery
        )
    }
    
    func performInteractionForVisibleElement(
        resolvedElementQuery: ResolvedElementQuery,
        interactionSpecificImplementation: InteractionSpecificImplementation,
        performingSpecificImplementationCanBeRepeated: Bool,
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
                    return elementIsNotUniqueResult(resolvedElementQuery: resolvedElementQuery)
                }
            case .useElementAtIndexInHierarchy:
                break
            }
            
            if snapshot.isDefinitelyHidden.value == true {
                return elementIsHiddenResult()
            }
            
            let scrollingResult = scrollIfNeeded(
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
                
                retryingIsPossible = !performingSpecificImplementationCanBeRepeated
                
                switch result {
                case .success:
                    return .success
                case .failure(let interactionSpecificFailure):
                    return failureResult(
                        interactionSpecificFailure: interactionSpecificFailure,
                        message: "\(closureFailureMessage): \(interactionSpecificFailure.message)"
                    )
                }
            } else {
                return elementIsNotSufficientlyVisibleResult(
                    percentageOfVisibleArea: percentageOfVisibleArea,
                    scrollingFailureMessage: scrollingFailureMessage
                )
            }
        } else {
            return elementIsNotFoundResult(resolvedElementQuery: resolvedElementQuery)
        }
    }
    
    private func elementIsHiddenResult()
        -> InteractionResult
    {
        return failureResult(
            message: "элемент есть в иерархии, но спрятан"
        )
    }
    
    private func elementIsNotSufficientlyVisibleResult(
        percentageOfVisibleArea: CGFloat,
        scrollingFailureMessage: String?)
        -> InteractionResult
    {
        let suffix = scrollingFailureMessage.flatMap { message in
            ", на это могла повлиять ошибка при скроллинге: \(message)"
        }
        
        return failureResult(
            message: "элемент не полностью видим"
                + " (видимая площадь: \(percentageOfVisibleArea),"
                + " ожидалось: \(minimalPercentageOfVisibleArea))"
                + (suffix ?? "")
        )
    }
    
    private func elementIsNotFoundResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    {
        return failureResult(
            resolvedElementQuery: resolvedElementQuery,
            message: "элемент не найден в иерархии"
        )
    }
    
    private func elementIsNotUniqueResult(
        resolvedElementQuery: ResolvedElementQuery)
        -> InteractionResult
    {
        return failureResult(
            resolvedElementQuery: resolvedElementQuery,
            message: "найдено несколько элементов по заданным критериям"
        )
    }
    
    func failureResult(
        resolvedElementQuery: ResolvedElementQuery? = nil,
        interactionSpecificFailure: InteractionSpecificFailure? = nil,
        message: String)
        -> InteractionResult
    {
        return .failure(
            InteractionFailureMaker.interactionFailure(
                message: "\(messagePrefix) (\(interactionName)) - \(message)",
                elementFindingFailure: resolvedElementQuery?.candidatesDescription(),
                currentElementSnapshots: resolvedElementQuery?.knownSnapshots,
                interactionSpecificFailure: interactionSpecificFailure
            )
        )
    }
    
    private func respectPollingConfiguration() {
        if case PollingConfiguration.reduceWorkload = pollingConfiguration {
            RunLoop.current.run(until: Date().addingTimeInterval(1.0))
        }
    }
}
