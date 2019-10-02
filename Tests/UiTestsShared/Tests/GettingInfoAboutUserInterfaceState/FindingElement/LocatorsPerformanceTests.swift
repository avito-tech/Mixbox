// At the time this test was added it took 830s (I cancelled it) and it allocated 20GB RAM.
// If it passes, then it's fine (there are timeouts for tests on CI). It was optimized to run in several tens of seconds.

final class LocatorsPerformanceTests: TestCase {
    private var screen: LocatorsPerformanceTestsViewPageObject {
        return pageObjects.locatorsPerformanceTestsView
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(screen)
    }
    
    func test___complex_is_subview_matcher___passes_in_timeout___when_matches() {
        screen.element(path: [1, 1, 1, 1, 1, 1]).assertHasText("555")
    }
    
    func test___complex_is_subview_matcher___passes_in_timeout___when_it_doesnt_match() {
        assertFails {
            screen.element(path: [1, 1, 1, 1, 1, 4]).assertIsDisplayed()
        }
    }
}
