import MixboxUiTestsFoundation
import XCTest
import MixboxIpcCommon
import MixboxIpcClients

// TODO: Share with GreyBox?
final class ScrollerImpl: Scroller {
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let elementResolver: ElementResolver
    private let applicationProvider: ApplicationProvider
    private let applicationCoordinatesProvider: ApplicationCoordinatesProvider
    private let elementSettings: ElementSettings
    
    init(
        scrollingHintsProvider: ScrollingHintsProvider,
        elementVisibilityChecker: ElementVisibilityChecker,
        elementResolver: ElementResolver,
        applicationProvider: ApplicationProvider,
        applicationCoordinatesProvider: ApplicationCoordinatesProvider,
        elementSettings: ElementSettings)
    {
        self.scrollingHintsProvider = scrollingHintsProvider
        self.elementVisibilityChecker = elementVisibilityChecker
        self.elementResolver = elementResolver
        self.applicationProvider = applicationProvider
        self.applicationCoordinatesProvider = applicationCoordinatesProvider
        self.elementSettings = elementSettings
    }
    
    func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
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
        
        if snapshot.frameOnScreen == .zero {
            // Fake cells have .zero accessibilityFrame, even if we set the value of it.
            // Probably, AX Client just ignores it if the element has no superview.
            
            // Need to scroll.
        } else {
            let frame = applicationCoordinatesProvider.frame
            
            if frame.mb_intersectionOrNil(snapshot.frameOnScreen) != nil {
                // Element intersects screen.
                // We don't care if it is fully on screen or partially.
                // We just filter out the case when it is completely off screen.
                //
                // If element is partially on screen it might be "sufficiently visible" (and vice versa).
                // If it is fully on screen it can also be either sufficiently visible ot not.
                //
                // So in any case we must do the check if it is not comopletely off screen.
                let percentageOfVisibleArea = elementVisibilityChecker.percentageOfVisibleArea(
                    snapshot: snapshot
                )
                
                let elementIsSufficientlyVisible = percentageOfVisibleArea >= minimalPercentageOfVisibleArea
                
                if elementIsSufficientlyVisible {
                    // sufficiently visible
                    
                    return ScrollingResult(
                        status: .alreadyVisible(percentageOfVisibleArea: percentageOfVisibleArea),
                        updatedSnapshot: snapshot,
                        updatedResolvedElementQuery: resolvedElementQuery
                    )
                } else {
                    // not sufficiently visible
                }
            } else {
                // off screen / can not be visible
            }
        }
        
        let scrollingContext = ScrollingContext(
            snapshot: snapshot,
            expectedIndexOfSnapshotInResolvedElementQuery: expectedIndexOfSnapshotInResolvedElementQuery,
            resolvedElementQuery: resolvedElementQuery,
            scrollingHintsProvider: scrollingHintsProvider,
            elementVisibilityChecker: elementVisibilityChecker,
            minimalPercentageOfVisibleArea: minimalPercentageOfVisibleArea,
            applicationProvider: applicationProvider,
            applicationCoordinatesProvider: applicationCoordinatesProvider,
            elementResolver: elementResolver
        )
        
        return scrollingContext.scrollIfNeeded()
    }
}
