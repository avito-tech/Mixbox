import MixboxUiTestsFoundation
import XCTest

final class ChecksTests: TestCase {
    func test() {
        openScreen(name: "ChecksTestsView")
        
        let screen = pageObjects.checksTests
        
        // Каждая проверка сопровождается проверкой на то, что обратная проверка не отрабатывается.
        // Чтобы не было такого, что isDisplayed() и isNotDisplayed() отрабатывали одновременно для одного и того же элемента.
        
        screen.label("checkText0").assert.checkAccessibilityLabel { $0 == "Полное соответствие" }
        XCTAssertFalse(
            screen.label("checkText0").checkAccessibilityLabel { $0 != "Полное соответствие" }
        )
        
        XCTAssertEqual(
            screen.label("checkText0").assert.visibleText(),
            "Полное соответствие"
        )
        
        screen.label("checkText1").assert.checkAccessibilityLabel { $0.starts(with: "Частичное соотве") }
        XCTAssertFalse(
            screen.label("checkText1").checkAccessibilityLabel { !$0.starts(with: "Частичное соотве") }
        )
        
        screen.label("hasValue0").assert.hasValue("Accessibility Value")
        XCTAssertFalse(
            screen.label("hasValue0").hasValue("Other Accessibility Value")
        )
        
        screen.label("isNotDisplayed0").withoutTimeout.assert.isNotDisplayed()
        XCTAssertFalse(
            screen.label("isNotDisplayed0").isDisplayed()
        )
        
        screen.label("isNotDisplayed1").withoutTimeout.assert.isNotDisplayed()
        XCTAssertFalse(
            screen.label("isNotDisplayed1").isDisplayed()
        )
        
        screen.label("isDisplayed0").assert.isDisplayed()
        XCTAssertFalse(
            screen.label("isDisplayed0").withoutTimeout.isNotDisplayed()
        )
        
        screen.button("isEnabled0").assert.isEnabled()
        XCTAssertFalse(
            screen.button("isEnabled0").isDisabled()
        )
        
        screen.button("isDisabled0").assert.isDisabled()
        XCTAssertFalse(
            screen.button("isDisabled0").isEnabled()
        )
        
        // TODO:
//        func isScrollable(checkSettings: CheckSettings) -> Bool
//
//        func matchesReference(snapshot: String, checkSettings: CheckSettings) -> Bool
    }
}

private final class ChecksTestsScreen: BasePageObjectWithDefaultInitializer {
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button \(id)") { element in element.id == id }
    }
}

private extension PageObjects {
    var checksTests: ChecksTestsScreen {
        return pageObject()
    }
}
