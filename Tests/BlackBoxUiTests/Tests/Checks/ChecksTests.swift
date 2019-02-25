import MixboxUiTestsFoundation
import XCTest

final class ChecksTests: TestCase {
    private var screen: ChecksTestsScreen {
        return pageObjects.checksTests
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(name: "ChecksTestsView")
        
        // Wait until UI is loaded
        screen.view("ChecksTestsView").assert.isDisplayed()
    }
    
    // Каждая проверка сопровождается проверкой на то, что обратная проверка не отрабатывается.
    // Чтобы не было такого, что isDisplayed() и isNotDisplayed() отрабатывали одновременно для одного и того же элемента.
    
    func test_checkText() {
        screen.label("checkText0").withoutTimeout.assert.checkAccessibilityLabel { $0 == "Полное соответствие" }
        XCTAssertFalse(
            screen.label("checkText0").withoutTimeout.checkAccessibilityLabel { $0 != "Полное соответствие" }
        )
        
        XCTAssertEqual(
            screen.label("checkText0").withoutTimeout.assert.visibleText(),
            "Полное соответствие"
        )
        
        screen.label("checkText1").withoutTimeout.assert.checkAccessibilityLabel { $0.starts(with: "Частичное соотве") }
        XCTAssertFalse(
            screen.label("checkText1").withoutTimeout.checkAccessibilityLabel { !$0.starts(with: "Частичное соотве") }
        )
    }
    
    func test_hasValue() {
        screen.label("hasValue0").withoutTimeout.assert.hasValue("Accessibility Value")
        XCTAssertFalse(
            screen.label("hasValue0").withoutTimeout.hasValue("Other Accessibility Value")
        )
    }
    
    func test_isNotDisplayed() {
        screen.label("isNotDisplayed0").withoutTimeout.assert.isNotDisplayed()
        XCTAssertFalse(
            screen.label("isNotDisplayed0").withoutTimeout.isDisplayed()
        )
        
        screen.label("isNotDisplayed1").withoutTimeout.assert.isNotDisplayed()
        XCTAssertFalse(
            screen.label("isNotDisplayed1").withoutTimeout.isDisplayed()
        )
    }
    
    func test_isDisplayed() {
        screen.label("isDisplayed0").withoutTimeout.assert.isDisplayed()
        XCTAssertFalse(
            screen.label("isDisplayed0").withoutTimeout.isNotDisplayed()
        )
    }
    
    func test_isEnabled() {
        screen.button("isEnabled0").withoutTimeout.assert.isEnabled()
        XCTAssertFalse(
            screen.button("isEnabled0").withoutTimeout.isDisabled()
        )
    }
    
    func test_isDisabled() {
        screen.button("isDisabled0").withoutTimeout.assert.isDisabled()
        XCTAssertFalse(
            screen.button("isDisabled0").withoutTimeout.isEnabled()
        )
    }
    
    func test_becomesTallerAfter() {
        screen.button("collapseButton").withoutTimeout.tap()
        screen.label("expandingLabel").becomesTallerAfter { [weak self] in
            self?.screen.button("expandButton").withoutTimeout.tap()
        }
    }
    
    func test_becomesShorterAfter() {
        screen.button("expandButton").withoutTimeout.tap()
        screen.label("expandingLabel").becomesShorterAfter { [weak self] in
            self?.screen.button("collapseButton").withoutTimeout.tap()
        }
    }
}

private final class ChecksTestsScreen: BasePageObjectWithDefaultInitializer {
    func label(_ id: String) -> LabelElement {
        return element("label '\(id)'") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button '\(id)'") { element in element.id == id }
    }
    
    func view(_ id: String) -> ViewElement {
        return element("view '\(id)'") { element in element.id == id }
    }
}

private extension PageObjects {
    var checksTests: ChecksTestsScreen {
        return pageObject()
    }
}
