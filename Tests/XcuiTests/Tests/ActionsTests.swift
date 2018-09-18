import MixboxUiTestsFoundation

final class ActionsTests: TestCase {
    private var screen: ActionsTestsScreen {
        return pageObjects.actionsTests
    }
    
    private let numberOfSubsequentActions = 10
    
    override func precondition() {
        openScreen(name: "ActionsTestsView")
    }
    
    func test_tap() {
        // resetInfo performs tap, so it is not suitable for this test.
        // TODO: get received action via IPC?
        screen.button("tap").tap()
        screen.info.assert.hasAccessibilityLabel("tap")
    }
    
    func test_press() {
        for _ in 0..<numberOfSubsequentActions {
            screen.button("press").press(duration: 1.2)
            screen.info.assert.hasAccessibilityLabel("press")
            resetInfo()
        }
    }
    
    func test_setText() {
        for _ in 0..<numberOfSubsequentActions {
            screen.input("text").setText("Введенная строка")
            screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
            resetInfo()
        }
    }
    
    func test_typeText() {
        // TODO: Make consequent actions work?
        //for _ in 0..<numberOfSubsequentActions {
            screen.input("text").typeText("Введенная строка")
            screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
            resetInfo()
        //}
    }

    func test_pasteText() {
        // TODO: Make consequent actions work?
        //for _ in 0..<numberOfSubsequentActions {
            screen.input("text").pasteText("Введенная строка")
            screen.info.assert.hasAccessibilityLabel("text: Введенная строка")
            resetInfo()
        //}
    }

    func test_clearText() {
        for _ in 0..<numberOfSubsequentActions {
            screen.input("text").setText("Введенная строка")
            screen.input("text").clearText()
            screen.info.assert.hasAccessibilityLabel("text: ")
            resetInfo()
        }
    }
    
    func test_swipes() {
        for _ in 0..<numberOfSubsequentActions {
            screen.label("swipeUp").swipeUp()
            screen.info.withoutTimeout.assert.hasText("swipeUp")
            resetInfo()

            screen.label("swipeDown").swipeDown()
            screen.info.withoutTimeout.assert.hasText("swipeDown")
            resetInfo()

            screen.label("swipeLeft").swipeLeft()
            screen.info.withoutTimeout.assert.hasText("swipeLeft")
            resetInfo()

            screen.label("swipeRight").swipeRight()
            screen.info.withoutTimeout.assert.hasText("swipeRight")
            resetInfo()
        }
    }
    
    // To remove false positives (see pseudocode):
    //
    // Without `resetInfo`:
    //
    // info = "x"
    // assert(info = "x")
    // info = "x" // <- if this fails
    // assert(info = "x") // <- this will pass
    //
    // With `resetInfo`:
    //
    // info = "x"
    // assert(info = "x")
    // resetInfo()
    // info = "x" // <- if this fails
    // assert(info = "x") // <- this will fail
    //
    private func resetInfo() {
        screen.button("tap").tap()
        screen.info.assert.hasText("tap")
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
