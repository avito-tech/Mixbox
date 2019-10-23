import MixboxUiTestsFoundation

final class ScrollingTests: TestCase {
    private struct DataSet {
        let viewName: String
    }
    
    override var reuseState: Bool {
        return false
    }
    
    // TODO: Support TableView and WebView
    
    func test_scrolling_works_inScrollView() {
        dataSetTest(dataSet: DataSet(viewName: "ScrollTestsScrollView"))
    }
    
    func test_scrolling_works_inCollectionView() {
        dataSetTest(dataSet: DataSet(viewName: "ScrollTestsCollectionView"))
    }
    
    private func dataSetTest(dataSet: DataSet) {
        openScreen(name: dataSet.viewName)
        
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
        
        pageObjects.scrollerTests.first.assertHasAccessibilityLabel("First") // #0
        pageObjects.scrollerTests.second.assertHasAccessibilityLabel("Second") // #1
        pageObjects.scrollerTests.third.assertHasAccessibilityLabel("Third") // #2
        pageObjects.scrollerTests.first.assertHasAccessibilityLabel("First") // #3
        pageObjects.scrollerTests.third.assertHasAccessibilityLabel("Third") // #4
        pageObjects.scrollerTests.second.assertHasAccessibilityLabel("Second") // #5
        pageObjects.scrollerTests.first.assertHasAccessibilityLabel("First") // #6
    }
}

private final class ScrollerTestsScreen: BasePageObjectWithDefaultInitializer {
    var first: LabelElement {
        return element("first") { element in element.id == "first" }
    }
    var second: LabelElement {
        return element("second") { element in element.id == "second" }
    }
    var third: LabelElement {
        return element("third") { element in element.id == "third" }
    }
}

private extension PageObjects {
    var scrollerTests: ScrollerTestsScreen {
        return pageObject()
    }
}
