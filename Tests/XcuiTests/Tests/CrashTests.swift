import MixboxUiTestsFoundation
import XCTest

final class CrashTests: TestCase {
    override func precondition() {
        // Tests rely on the fact that app process will not be debugged.
        // That's why we are installing app to not install it later in tests and to not start debugging it.
        openScreen(name: "CrashTestsView", useBuiltinIpc: true)
        XCUIApplication().terminate()
    }
    
    func test_kill_9() {
        check(element: pageObjects.screen.kill_9)
    }
    
    func test_div_0() {
        check(element: pageObjects.screen.div_0)
    }
    
    func test_exception() {
        check(element: pageObjects.screen.exception)
    }
    
    func check(element: ViewElement) {
        openScreen(name: "CrashTestsView", useBuiltinIpc: true)
        
        assertFails(
            description: """
                Проверка не прошла (отображается "view") - элемент не найден в иерархии, на это могло повлиять то, что приложение не запущено, либо закрешилось (state = notRunning)
                """)
        {
            element.tap()
            sleep(1)
            pageObjects.screen.view.withoutTimeout.assert.isDisplayed()
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    var view: ViewElement {
        return by(id: "view")
    }
    var kill_9: ViewElement {
        return by(id: "kill_9")
    }
    var exception: ViewElement {
        return by(id: "exception")
    }
    var div_0: ViewElement {
        return by(id: "div_0")
    }
    
    private func by(id: String) -> ViewElement {
        return element(id) {
            $0.id == id
        }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
