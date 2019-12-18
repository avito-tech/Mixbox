import XCTest
import MixboxIpcCommon

public final class ScrollerImpl: Scroller {
    private let scrollingHintsProvider: ScrollingHintsProvider
    private let elementVisibilityChecker: ElementVisibilityChecker
    private let elementResolver: ElementResolver
    private let applicationFrameProvider: ApplicationFrameProvider
    private let eventGenerator: EventGenerator
    private let elementSettings: ElementSettings
    
    public init(
        scrollingHintsProvider: ScrollingHintsProvider,
        elementVisibilityChecker: ElementVisibilityChecker,
        elementResolver: ElementResolver,
        applicationFrameProvider: ApplicationFrameProvider,
        eventGenerator: EventGenerator,
        elementSettings: ElementSettings)
    {
        self.scrollingHintsProvider = scrollingHintsProvider
        self.elementVisibilityChecker = elementVisibilityChecker
        self.elementResolver = elementResolver
        self.applicationFrameProvider = applicationFrameProvider
        self.eventGenerator = eventGenerator
        self.elementSettings = elementSettings
    }
    
    public func scrollIfNeeded(
        snapshot: ElementSnapshot,
        minimalPercentageOfVisibleArea: CGFloat,
        expectedIndexOfSnapshotInResolvedElementQuery: Int,
        resolvedElementQuery: ResolvedElementQuery)
        -> ScrollingResult
    {
        // TODO: Better code. These lines just disable scrolling with minimal number of lines and minimal consequences.
        // (at the moment the code was written, we all know what can happen with code if it will live for long)
        if elementSettings.scrollMode == .none {
            return ScrollingResult(
                status: .scrolled, // this is a lie, but without consequences
                updatedSnapshot: snapshot,
                updatedResolvedElementQuery: resolvedElementQuery
            )
        }
        
        if snapshot.frameRelativeToScreen == .zero {
            // Fake cells have .zero accessibilityFrame, even if we set the value of it.
            // Probably, AX Client just ignores it if the element has no superview.
            
            // Need to scroll.
        } else {
            let frame = applicationFrameProvider.applicationFrame
            
            if frame.mb_intersectionOrNil(snapshot.frameRelativeToScreen) != nil {
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
            applicationFrameProvider: applicationFrameProvider,
            eventGenerator: eventGenerator,
            elementResolver: elementResolver
        )
        
        return scrollingContext.scrollIfNeeded()
    }
}
