import MixboxUiTestsFoundation

final class ScrollingTests: TestCase {
    private struct DataSet {
        let viewName: String
    }
    
    // TODO: Добавить TableView и WebView
    
    func test_scrolling_works_inScrollView() {
        dataSetTest(dataSet: DataSet(viewName: "ScrollTestsScrollView"))
    }
    
    func test_scrolling_works_inCollectionView() {
        dataSetTest(dataSet: DataSet(viewName: "ScrollTestsCollectionView"))
    }
    
    private func dataSetTest(dataSet: DataSet) {
        openScreen(name: dataSet.viewName)
        
        // Тестим все комбинации скролла.
        // На скроллвью first расположена вверху, third внизу.
        // В первом тесте сразу видно first.
        // Во втором перемещаемся от first к second (от верха к середине).
        // Остальное отражено в схеме.
        //
        // test no: 0 1 2 3 4 5 6
        //
        // first    v |   ^ |   ^
        // second     v | | | ^ |
        // third        v | v |
        
        pageObjects.scrollerTests.first.assert.hasAccessibilityLabel("First")
        pageObjects.scrollerTests.second.assert.hasAccessibilityLabel("Second")
        pageObjects.scrollerTests.third.assert.hasAccessibilityLabel("Third")
        pageObjects.scrollerTests.first.assert.hasAccessibilityLabel("First")
        pageObjects.scrollerTests.third.assert.hasAccessibilityLabel("Third")
        pageObjects.scrollerTests.second.assert.hasAccessibilityLabel("Second")
        pageObjects.scrollerTests.first.assert.hasAccessibilityLabel("First")
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
