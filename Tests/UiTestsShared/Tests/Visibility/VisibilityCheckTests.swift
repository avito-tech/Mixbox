import XCTest
import TestsIpc
import MixboxUiTestsFoundation
import MixboxUiKit

final class VisibilityCheckTests: TestCase {
    private var screen: IpcTestingViewPageObject {
        return pageObjects.ipcTestingView.default
    }
    
    private let checkedViewId = "checkedView"
    
    private lazy var screenScale = mainScreenScale()
    private lazy var screenBounds = mainScreenBounds()
    
    // If VisibilityCheckForLoopOptimizerImpls's numberOfPointsInGrid equals to 10000
    // then accuracy is limited to about 0.0199 for a square view for cases when view is sligtly overlapped
    // in corners, because side of grid will be 100 and pixels outside of grid can be about 1/100th of a side
    // (minus 2 pixels on the corners), so accuracy is about `1 - sqr(99/100)` ~= 0.0199
    private let accuracy: CGFloat = 0.0199
    
    private var checkedView: ViewElement {
        return screen.byId(checkedViewId)
    }
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.ipcTestingView)
            .waitUntilViewIsLoaded()
    }
    
    func test() {
        check(percentageOfVisibleArea: 0)
        check(percentageOfVisibleArea: 0.1)
        check(percentageOfVisibleArea: 0.5)
        check(percentageOfVisibleArea: 0.9)
        check(percentageOfVisibleArea: 1)
        
        // Corner cases (if `percentageOfVisibleArea` is 1 then strict check should be enforced
        _ = resetUiOverlappingAllSidesOfSquareAndReturnFactualPercentageOfVisibleArea(
            percentageOfVisibleArea: 0.999
        )
        assertFails {
            checkedView
                .with(percentageOfVisibleArea: 1)
                .withoutTimeout
                .assertIsDisplayed()
        }
    }
    
    func check(percentageOfVisibleArea: CGFloat) {
        let factualPercentageOfVisibleArea = resetUiOverlappingAllSidesOfSquareAndReturnFactualPercentageOfVisibleArea(
            percentageOfVisibleArea: percentageOfVisibleArea
        )
        
        if factualPercentageOfVisibleArea > 0 {
            checkedView
                .with(percentageOfVisibleArea: factualPercentageOfVisibleArea - accuracy)
                .withoutTimeout
                .assertIsDisplayed()
        }
        
        if factualPercentageOfVisibleArea < 1 {
            assertFails {
                checkedView
                    .with(percentageOfVisibleArea: factualPercentageOfVisibleArea + accuracy)
                    .withoutTimeout
                    .assertIsDisplayed()
            }
        }
    }
    
    // This test overlaps view starting from its corners.
    //
    // This test was added after a bug with "grid optimization" (see `VisibilityCheckForLoopOptimizer`).
    //
    // The optimization reduces number of checked pixels to a grid of fixed number of pixels,
    // but because of that, some pixels at the borders of view became unchecked, because they are outside of grid
    // and some tests failed to scroll to view properly (scroller was thinking that view is
    // 100% visible, but in fact it was not).
    //
    // The solution is to check if optimization is appropriate. For example, if we want to check if view is
    // exactly 100% visible, we should check 100% of its pixels. The other thing is that if check requires certain
    // accuracy then grid should provide such accuracy ("accuracy" was not implemented at the moment this
    // is written, but it is a logical thing to do).
    //
    // Overlapping goes this way:
    //
    // ...............    XXXXXXXXXXXXXXX    XXXXXXXXXXXXXXX
    // ...............    XX...........XX    XXXXXXXXXXXXXXX
    // ...............    XX...........XX    XXXX.......XXXX
    // ............... => XX...........XX => XXXX.......XXXX
    // ...............    XX...........XX    XXXX.......XXXX
    // ...............    XX...........XX    XXXXXXXXXXXXXXX
    // ...............    XXXXXXXXXXXXXXX    XXXXXXXXXXXXXXX
    //
    private func resetUiOverlappingAllSidesOfSquareAndReturnFactualPercentageOfVisibleArea(
        percentageOfVisibleArea: CGFloat)
        -> CGFloat
    {
        let bounds = screenBounds
        
        let checkedViewFrame = self.checkedViewFrame(
            bounds: bounds
        )
        
        let visibleRectFrame = self.visibleRectFrame(
            checkedViewFrame: checkedViewFrame,
            bounds: bounds,
            percentageOfVisibleArea: percentageOfVisibleArea
        )
        
        let checkedView = IpcView(
            frame: checkedViewFrame,
            accessibilityIdentifier: "checkedView",
            backgroundColor: .green
        )
        
        let overlappingRects = self.overlappingRects(
            visibleRectFrame: visibleRectFrame,
            checkedViewFrame: checkedViewFrame
        )
        
        let overlappingViews = overlappingRects.map { frame in
            IpcView(
                frame: frame,
                accessibilityIdentifier: nil,
                backgroundColor: .gray
            )
        }
        
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: [checkedView] + overlappingViews
            )
        )
        
        return visibleRectFrame.mb_area / checkedViewFrame.mb_area
    }
    
    private func resetUi(
        views: [IpcView])
    {
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: views
            )
        )
    }
    
    private func overlappingRects(
        visibleRectFrame: CGRect,
        checkedViewFrame: CGRect
    ) -> [CGRect] {
        return [
            // Left
            CGRect.mb_init(
                left: checkedViewFrame.mb_left,
                right: visibleRectFrame.mb_left,
                top: checkedViewFrame.mb_top,
                bottom: checkedViewFrame.mb_bottom
            ),
            // Right
            CGRect.mb_init(
                left: visibleRectFrame.mb_right,
                right: checkedViewFrame.mb_right,
                top: checkedViewFrame.mb_top,
                bottom: checkedViewFrame.mb_bottom
            ),
            // Top
            CGRect.mb_init(
                left: checkedViewFrame.mb_left,
                right: checkedViewFrame.mb_right,
                top: checkedViewFrame.mb_top,
                bottom: visibleRectFrame.mb_top
            ),
            // Bottom
            CGRect.mb_init(
                left: checkedViewFrame.mb_left,
                right: checkedViewFrame.mb_right,
                top: visibleRectFrame.mb_bottom,
                bottom: checkedViewFrame.mb_bottom
            )
        ]
    }
    
    // Just a maximal square in bounds. To simplify calculation.
    private func checkedViewFrame(bounds: CGRect) -> CGRect {
        let checkedViewSide = min(bounds.width, bounds.height)
        
        var checkedViewFrame = CGRect(
            origin: .zero,
            size: CGSize(
                width: checkedViewSide,
                height: checkedViewSide
            )
        )
        
        checkedViewFrame.mb_center = bounds.mb_center
        
        return checkedViewFrame
    }
    
    private func visibleRectFrame(
        checkedViewFrame: CGRect,
        bounds: CGRect,
        percentageOfVisibleArea: CGFloat)
        -> CGRect
    {
        let checkedViewArea = checkedViewFrame.mb_area
        
        // Computation works for squares only
        XCTAssertEqual(checkedViewFrame.width, checkedViewFrame.height)
        
        let visibleArea = percentageOfVisibleArea * checkedViewArea
        let visibleRectSide = sqrt(visibleArea)
        var visibleRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: visibleRectSide,
                height: visibleRectSide
            )
        )
        visibleRect.mb_center = checkedViewFrame.mb_center
        
        // Visibility check ignores subpixels so do we in tests.
        // This should be changed if visibility check is changed.
        return visibleRect
            .mb_pointToPixel(scale: screenScale)
            .mb_integralInside()
            .mb_pixelToPoint(scale: screenScale)
    }
}
