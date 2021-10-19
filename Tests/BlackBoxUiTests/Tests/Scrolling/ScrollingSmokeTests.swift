import MixboxUiTestsFoundation

final class ScrollingSmokeTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    private var screen: ScrollingSmokeTestsViewPageObject {
        return pageObjects.scrollingSmokeTestsView.default
    }
    
    // TODO: Support TableView and WebView
    
    func test_scrolling_works_inScrollView() {
        parameterized_test(viewName: "ScrollingSmokeTestsScrollView")
    }
    
    func test_scrolling_works_inCollectionView() {
        parameterized_test(viewName: "ScrollingSmokeTestsCollectionView")
    }
    
    private func parameterized_test(viewName: String) {
        openScreen(name: viewName)
        
        // The code tests every combination of scrolling.
        // There are three views: "first", "second", and "third".
        // Test case #0: First is already displayed. No scroll needed.
        // Test case #1: Need to scroll to the center of the scrollview to the bottom.
        // ...
        // Other test cases are displayed in this scheme:
        //
        // test no: 0 1 2 3 4 5 6
        //
        // first    v |   ^ |   ^
        // second     v | | | ^ |
        // third        v | v |
        
        screen.first.assertIsDisplayed() // #0
        screen.second.withoutTimeout.assertIsDisplayed() // #1
        screen.third.withoutTimeout.assertIsDisplayed() // #2
        screen.first.withoutTimeout.assertIsDisplayed() // #3
        screen.third.withoutTimeout.assertIsDisplayed() // #4
        screen.second.withoutTimeout.assertIsDisplayed() // #5
        screen.first.withoutTimeout.assertIsDisplayed() // #6
    }
}
