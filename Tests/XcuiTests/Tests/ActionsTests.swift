import MixboxUiTestsFoundation

final class ActionsTests: TestCase {
    private var screen: ActionsTestsScreen {
        return pageObjects.actionsTests
    }
    
    override func setUp() {
        super.setUp()
        openScreen(name: "ActionsTestsView")
    }
    
    func test_tap() {
        screen.button("tap").tap()
        screen.info.assert.hasAccessibilityLabel("tap")
    }
    
    func test_press() {
        screen.button("press").press(duration: 1.2)
        screen.info.assert.hasAccessibilityLabel("press")
    }
    
    func test_setText() {
        screen.input("text").setText("Введенная строка")
        screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
    }
    
    func test_typeText() {
        screen.input("text").typeText("Введенная строка")
        screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
    }

    func test_pasteText() {
        screen.input("text").pasteText("Введенная строка")
        screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
    }

    func test_clearText() {
        screen.input("text").pasteText("Введенная строка")
        screen.input("text").clearText()
        screen.info.assert.hasAccessibilityLabel("text: ")
    }
}

private final class ActionsTestsScreen: BasePageObjectWithDefaultInitializer {
    var info: LabelElement {
        return element("info") { element in element.id == "info" }
    }
    
    func label(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
    
    func button(_ id: String) -> ButtonElement {
        return element("button \(id)") { element in element.id == id }
    }
    
    func input(_ id: String) -> InputElement {
        return element("input \(id)") { element in element.id == id }
    }
}

private extension PageObjects {
    var actionsTests: ActionsTestsScreen {
        return pageObject()
    }
}
