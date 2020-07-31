final class VisibilityCheckPerformanceTests: TestCase {
    private var screen: ScreenshotTestsViewPageObject {
        return pageObjects.screenshotTestsView.default
    }
    
    override var reuseState: Bool {
        return false
    }
    
    override func precondition() {
        super.precondition()
        
        open(screen: screen)
            .waitUntilViewIsLoaded()
    }
    
    func test___interaction_without_target_coordinates() {
        // At the moment (2020.07.28), after optimization of visibility check, on Macbook Pro 2018 i9.
        // 100 cycles: 38.660s
        // 200 cycles: 74.965s
        for _ in 0..<100 {
            _ = screen.view.isDisplayed()
        }
    }
    
    // There is a logic in scroller. Scroller checks view always. But to avoid double checking
    // the result of visibility check from scroller is reused after scrolling, when interaction is performed,
    // including coordinates of visible pixel (equal or closest to target).
    func test___interaction_with_target_coordinates() {
        // At the moment (2020.07.28), after optimization of visibility check, on Macbook Pro 2018 i9.
        // 20 cycles: 15.095s
        for _ in 0..<20 {
            _ = screen.view.tap()
        }
    }
}
