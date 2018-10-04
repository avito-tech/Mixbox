import MixboxUiTestsFoundation

final class FakeCellsDoNotCrashAppTests: TestCase {
    override var reuseState: Bool {
        return false
    }
    
    func test() {
        openScreen(name: "FakeCellsDoNotCrashAppTestsView")
        
        // Fallback: visible cells are present in hierarchy
        pageObjects.screen.goodCell(index: 0).assert.isDisplayed()
        
        // Crashing fake cells are obviously not present in hierarchy
        pageObjects.screen.crashingCell(index: 0).assert.isNotDisplayed()
        pageObjects.screen.cellThatCrashesAtInit(index: 0).assert.isNotDisplayed()
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func goodCell(index: Int) -> ViewElement {
        return element("GoodCell") { element in
            element.id == "GoodCell" && element.customValues["index"] == index
        }
    }
    func crashingCell(index: Int) -> ViewElement {
        return element("CrashingCell") { element in
            element.id == "GoodCrashingCellCell" && element.customValues["index"] == index
        }
    }
    func cellThatCrashesAtInit(index: Int) -> ViewElement {
        return element("CellThatCrashesAtInit") { element in
            element.id == "CellThatCrashesAtInit" && element.customValues["index"] == index
        }
    }
}

private extension PageObjects {
    var screen: Screen {
        return apps.mainXcui.pageObject()
    }
}
