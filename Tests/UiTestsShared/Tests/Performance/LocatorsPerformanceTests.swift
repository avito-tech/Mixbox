// At the time this test was added, a single iteration took 830s and it allocated 20GB RAM.
// If it passes, then it's fine (there are timeouts for tests on CI).
//
// Currently it runs in 185.689s (all tests, Apple M1 Max, debugging enabled)
//
final class LocatorsPerformanceTests: TestCase {
    private var screen: LocatorsPerformanceTestsViewPageObject {
        return pageObjects.locatorsPerformanceTestsView.default
    }
    
    override var reuseState: Bool {
        return false
    }
    
    private let iterations = 10
    
    override func precondition() {
        super.precondition()
        
        open(screen: screen)
            .waitUntilViewIsLoaded()
    }
    
    func test___complex_is_subview_matcher___passes_in_timeout___when_matches() {
        for _ in 0..<iterations {
            screen.element(path: [1, 1, 1, 1, 1, 1]).withoutTimeout.assertHasText("555")
        }
    }
    
    func test___complex_is_subview_matcher___passes_in_timeout___when_it_doesnt_match() {
        for _ in 0..<iterations {
            assertFails {
                screen.element(path: [1, 1, 1, 1, 1, 4]).withoutTimeout.assertIsDisplayed()
            }
        }
    }
}
