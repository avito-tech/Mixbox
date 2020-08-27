import TestsIpc
import MixboxUiTestsFoundation
import MixboxIpcCommon
import UIKit

final class ScrollingTriesToMakeViewFullyVisibleTests: TestCase {
    override func precondition() {
        super.precondition()
        
        open(screen: screen).waitUntilViewIsLoaded()
    }
    
    func test___scrolling___tries_to_make_view_fully_visible___by_scrolling_to_center() {
        check___scrolling___tries_to_make_view_fully_visible(
            overlappingRatio: 0.4 // center of scroll view will not be overlapped
        )
    }
    
    // TODO: Fix. Currently scroller scrolls until element is centered in scroll view.
    //       1. Ideally it should scroll until element is centered in a visible area in scroll view.
    //       2. More ideally it should scroll until point of tap is somewhere inside visible area in scroll view.
    //          The difference from #1 is that visible area of scroll view might be less than element and coordinate of
    //          tap might be just outside of visible area of scroll view if element is centered in visible area, for
    //          example, if coordinate of tap is at the bottom of view.
    func disabled_test___scrolling___tries_to_make_view_fully_visible___by_scrolling_to_visible_area_of_scrollview() {
        check___scrolling___tries_to_make_view_fully_visible(
            overlappingRatio: 0.55 // center of scroll view will be overlapped
        )
    }
    
    private func check___scrolling___tries_to_make_view_fully_visible(overlappingRatio: CGFloat) {
        // Multiple tests with different offsets in UI are needed to avoid test passing by chance.
        let testsCount = 10
        for testIndex in 0..<testsCount {
            resetUi(
                randomizedOffset: 111 * CGFloat(testIndex),
                overlappingRatio: overlappingRatio // center of scroll view will not be overlapped
            )
            
            screen.button.withoutTimeout.assert(isTapped: false)
            screen.button.tap()
            screen.button.withoutTimeout.assert(isTapped: true)
        }
        
    }
    
    private func resetUi(randomizedOffset: CGFloat, overlappingRatio: CGFloat) {
        var bounds = mainScreenBounds()
        
        // to make center of scrollview not overlapped (to allow scroll;
        // this is a todo-thing to allow scroll by only a visible part)
        bounds = bounds.mb_shrinked(top: 0, left: 0, bottom: 0, right: 50)
        
        resetUi(
            argument: ScrollingTriesToMakeViewFullyVisibleTestsViewConfiguration(
                buttonFrame: CGRect(
                    x: 0,
                    y: bounds.height + randomizedOffset,
                    width: bounds.width,
                    height: bounds.height / 3
                ),
                contentSize: CGSize(
                    width: bounds.width,
                    height: 1000000
                ),
                overlappingViewFrame: CGRect.mb_init(
                    bottom: bounds.mb_bottom,
                    centerX: bounds.mb_centerX,
                    size: CGSize(
                        width: 10,
                        height: bounds.height * overlappingRatio
                    )
                )
            )
        )
    }
    
    private var screen: ScrollingTriesToMakeViewFullyVisibleTestsViewPageObject {
        return pageObjects.scrollingTriesToMakeViewFullyVisibleTestsView.default
    }
}
