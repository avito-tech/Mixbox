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
    
    func test() {
        // At the moment (2020.07.28), after optimization of visibility check, on Macbook Pro 2018 i9.
        // 100 cycles: 38.660s
        // 200 cycles: 74.965s
        for _ in 0..<100 {
            _ = screen.view.isDisplayed()
        }
    }
}
