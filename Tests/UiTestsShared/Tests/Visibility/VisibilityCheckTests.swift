import XCTest
import TestsIpc
import MixboxUiTestsFoundation
import MixboxUiKit

// TODO: Split
// swiftlint:disable type_body_length file_length
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
    // The test was added after a bug with "grid optimization", but in fact the bug was much simpler
    // than I thought (see `test___visibility_check___respects_position_of_view_relative_to_screen_bounds`)
    //
    // The idea was to make tests fail if view was overlapped slightly from sides, but pixels from grid was not
    // overlapped. Such check would trigger false positive results in edge cases (e.g. when required percentage
    // of visible area is 100%, actual percentage of visible area is 99%, but visibility check will tell that it's
    // 100% visible for example.
    //
    // This is really an edge case and for such cases a modifier `with(pixelPerfectVisibilityCheck: true)` was added.
    //
    // I think that real tests will never use this modifier, however, it is a must have for pixel perfect
    // image comparation.
    //
    func test___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped() {
        check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
            percentageOfVisibleArea: 0
        )
        check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
            percentageOfVisibleArea: 0.1
        )
        check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
            percentageOfVisibleArea: 0.5
        )
        check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
            percentageOfVisibleArea: 0.9
        )
        check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
            percentageOfVisibleArea: 1
        )
    }
    
    func test___visibility_check___respects_visibility_check_optimization_settings() {
        let onePixelSize = 1 / screenScale
        
        _ = resetUiOverlappingOneSideOfSquare(
            overlappingWidth: onePixelSize
        )
        
        // Actually 1 line of pixels is not visible and check is accurate.
        // The check should fail.
        assertFails {
            checkedView
                .with(pixelPerfectVisibilityCheck: true)
                .with(percentageOfVisibleArea: 1)
                .withoutTimeout
                .assertIsDisplayed()
        }
        
        // This is expected on square views vastly larger than 100 pixels in size (for every iPhone screen).
        // The check is not very accurate (it skips few pixels between pixels in grid, once every 10 pixels
        // on iPhone X for this view, assuming width is 1125 pixels). For iPhone 11 Pro Max it's even more pixels:
        // 2688 x 1242 = 3 338 496. And it's a good thing we skip them, because mathematics are 333 times faster for
        // this case.
        assertPasses {
            checkedView
                .with(pixelPerfectVisibilityCheck: false)
                .with(percentageOfVisibleArea: 1)
                .withoutTimeout
                .assertIsDisplayed()
        }
    }
    
    func test___visibility_check___respects_position_of_view_relative_to_screen_bounds() {
        check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
            percentageOfVisibleArea: 0
        )
        check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
            percentageOfVisibleArea: 0.1
        )
        check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
            percentageOfVisibleArea: 0.5
        )
        check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
            percentageOfVisibleArea: 0.9
        )
        check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
            percentageOfVisibleArea: 1
        )
    }
    
    func test___visibility_check___fails___if_view_is_hidden() {
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: [makeCheckedIpcView(
                    frame: centeredViewFrame(bounds: screenBounds),
                    isHidden: true
                )]
            )
        )
        
        assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
            actualPercentageOfVisibleArea: 0
        )
    }
    
    func test___visibility_check___fails___if_view_is_transparent() {
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: [makeCheckedIpcView(
                    frame: centeredViewFrame(bounds: screenBounds),
                    alpha: 0
                )]
            )
        )
        
        assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
            actualPercentageOfVisibleArea: 0
        )
    }
    
    func test___visibility_check___fails___if_view_has_zero_area() {
        check___visibility_check___fails___if_view_has_zero_area(
            size: CGSize(width: 0, height: 0)
        )
        check___visibility_check___fails___if_view_has_zero_area(
            size: CGSize(width: 0, height: 1)
        )
        check___visibility_check___fails___if_view_has_zero_area(
            size: CGSize(width: 1, height: 0)
        )
    }
    
    private func check___visibility_check___fails___if_view_has_zero_area(size: CGSize) {
        XCTAssertEqual(size.mb_area, 0)
        
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: [makeCheckedIpcView(
                    frame: CGRect(origin: screenBounds.mb_center, size: size)
                )]
            )
        )
        
        assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
            actualPercentageOfVisibleArea: 0
        )
    }
    
    private func check___visibility_check___respects_percentage_of_visible_area_when_view_is_overlapped(
        percentageOfVisibleArea: CGFloat)
    {
        let actualPercentageOfVisibleArea = resetUiOverlappingAllSidesOfSquare(
            percentageOfVisibleArea: percentageOfVisibleArea
        )
        
        assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
            actualPercentageOfVisibleArea: actualPercentageOfVisibleArea
        )
    }
    
    private func check___visibility_check___respects_position_of_view_relative_to_screen_bounds(
        percentageOfVisibleArea: CGFloat)
    {
        let actualPercentageOfVisibleArea = resetUiPlacingCheckedViewOutsideOfScreenBounds(
            percentageOfVisibleArea: percentageOfVisibleArea
        )
        
        assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
            actualPercentageOfVisibleArea: actualPercentageOfVisibleArea
        )
    }
    
    // E.g. if view was set up the way that it is 50% visible then visibility check
    // will fail if `minimalMercentageOfVisibleArea` > 50% (e.g. 51%)
    // and succeed if `minimalMercentageOfVisibleArea` < 50% (e.g. 49%)
    private func assertVisibilityCheckReturnsDifferentResultsOnBoundaryOfPercentageOfVisibleArea(
        actualPercentageOfVisibleArea: CGFloat)
    {
        XCTAssertGreaterThan(accuracy, 0, "This test makes no sense if accuracy is 0")
        
        if actualPercentageOfVisibleArea > 0 {
            checkedView
                .with(percentageOfVisibleArea: actualPercentageOfVisibleArea - accuracy)
                .withoutTimeout
                .assertIsDisplayed()
        }
        
        if actualPercentageOfVisibleArea < 1 {
            assertFails {
                checkedView
                    .with(percentageOfVisibleArea: actualPercentageOfVisibleArea + accuracy)
                    .withoutTimeout
                    .assertIsDisplayed()
            }
        }
    }
    
    private func resetUiOverlappingAllSidesOfSquare(
        percentageOfVisibleArea: CGFloat)
        -> CGFloat
    {
        return resetUiOverlappingAllSidesOfSquare(
            visibleRectMaker: { checkedViewFrame in
                visibleRectFrameWhenOverlappingAllSidesOfSquare(
                    checkedViewFrame: checkedViewFrame,
                    percentageOfVisibleArea: percentageOfVisibleArea
                )
            }
        )
    }
    
    private func resetUiOverlappingOneSideOfSquare(
        overlappingWidth: CGFloat)
        -> CGFloat
    {
        // 3 sides will be overlapped by 0 points and 1 by `overlappingWidth` points
        return resetUiOverlappingAllSidesOfSquare(
            visibleRectMaker: { checkedViewFrame in
                visibleRectFrameWhenOverlappingOneSideOfSquare(
                    checkedViewFrame: checkedViewFrame,
                    overlappingWidth: overlappingWidth
                )
            }
        )
        
    }
    
    private func resetUiOverlappingAllSidesOfSquare(
        visibleRectMaker: (_ checkedViewFrame: CGRect) -> CGRect)
        -> CGFloat
    {
        let bounds = screenBounds
        
        let checkedViewFrame = self.centeredViewFrame(
            bounds: bounds
        )
        
        let visibleRectFrame = visibleRectMaker(
            checkedViewFrame
        )
        
        let checkedView = makeCheckedIpcView(
            frame: checkedViewFrame
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
    
    private func resetUiPlacingCheckedViewOutsideOfScreenBounds(
        percentageOfVisibleArea: CGFloat)
        -> CGFloat
    {
        let bounds = screenBounds
        
        var checkedViewFrame = self.centeredViewFrame(
            bounds: bounds
        )
        
        // Moving view outside of screen bounds
        checkedViewFrame.mb_left = (1 - percentageOfVisibleArea) * checkedViewFrame.width
        
        resetUi(
            argument: IpcTestingViewConfiguration(
                views: [makeCheckedIpcView(frame: checkedViewFrame)]
            )
        )
        
        let visibleArea = checkedViewFrame.mb_intersectionOrNil(bounds)?.mb_area ?? 0
        
        return visibleArea / checkedViewFrame.mb_area
    }
    
    private func makeCheckedIpcView(
        frame: CGRect,
        alpha: CGFloat = 1,
        isHidden: Bool = false)
        -> IpcView
    {
        return IpcView(
            frame: frame,
            accessibilityIdentifier: "checkedView",
            backgroundColor: .green,
            alpha: alpha,
            isHidden: isHidden
        )
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
    private func centeredViewFrame(bounds: CGRect) -> CGRect {
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
    
    private func visibleRectFrameWhenOverlappingAllSidesOfSquare(
        checkedViewFrame: CGRect,
        percentageOfVisibleArea: CGFloat)
        -> CGRect
    {
        let checkedViewArea = checkedViewFrame.mb_area
        
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
        
        return alignRectToPixelGrid(rect: visibleRect)
    }

    // Visibility check ignores subpixels so do we in tests.
    // This should be changed if visibility check is changed.
    private func alignRectToPixelGrid(rect: CGRect) -> CGRect {
        return rect
            .mb_pointToPixel(scale: screenScale)
            .mb_integralInside()
            .mb_pixelToPoint(scale: screenScale)
    }
    
    private func visibleRectFrameWhenOverlappingOneSideOfSquare(
        checkedViewFrame: CGRect,
        overlappingWidth: CGFloat)
        -> CGRect
    {
        var visibleRect = checkedViewFrame
        visibleRect.mb_width -= overlappingWidth
        
        // Visibility check ignores subpixels so do we in tests.
        // This should be changed if visibility check is changed.
        return alignRectToPixelGrid(rect: visibleRect)
    }
}
