import MixboxUiTestsFoundation
import MixboxFoundation

// TODO: Share with GrayBox
final class ElementResolverWithScrollingAndRetriesImpl: ElementResolverWithScrollingAndRetries {
    private let elementResolver: ElementResolver
    private let elementSettings: ElementSettings
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    private let retrier: Retrier
    
    init(
        elementResolver: ElementResolver,
        elementSettings: ElementSettings,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        retrier: Retrier)
    {
        self.elementResolver = elementResolver
        self.elementSettings = elementSettings
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.retrier = retrier
    }
    
    func resolveElementWithRetries(
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> ResolvedElementQuery
    {
        var resolvedElementQuery = resolveElement()
        
        resolvedElementQuery = reresolveElementWithRetriesIfNeeded(
            resolvedElementQuery: resolvedElementQuery,
            isPossibleToRetryProvider: isPossibleToRetryProvider
        )
        
        resolvedElementQuery = reresolveElementWithScrollingIfNeeded(
            resolvedElementQuery: resolvedElementQuery
        )
        
        return resolvedElementQuery
    }
    
    private func resolveElement() -> ResolvedElementQuery {
        return elementResolver.resolveElement()
    }
    
    private func reresolveElementWithRetriesIfNeeded(
        resolvedElementQuery: ResolvedElementQuery,
        isPossibleToRetryProvider: IsPossibleToRetryProvider)
        -> ResolvedElementQuery
    {
        return retrier.retry(
            firstAttempt: {
                resolvedElementQuery
            },
            everyNextAttempt: {
                resolveElement()
            },
            shouldRetry: { resolvedElementQuery in
                shouldRetryResolvingElement(resolvedElementQuery: resolvedElementQuery)
            },
            isPossibleToRetryProvider: isPossibleToRetryProvider
        )
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
            let scrollingDistance = 8
            
            for _ in 0..<scrollingDistance where needToScroll {
                scrollBlindly(up: true)
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
                scrollBlindly(up: false)
                resolvedElementQuery = resolveElement()
            }
        }
        
        return resolvedElementQuery
    }
    
    private func scrollBlindly(up: Bool) {
        let frame = applicationCoordinatesProvider.frame
        
        applicationProvider.application.center.press(
            forDuration: 0,
            thenDragTo: applicationCoordinatesProvider.tappableCoordinate(
                x: frame.mb_centerX,
                y: up ? 0 : frame.height
            )
        )
    }
}
