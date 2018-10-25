import MixboxUiTestsFoundation
import XCTest

final class FailureMessagesAreCorrectTests: TestCase {
    override func precondition() {
        openScreen(name: "FailuresTestsView")
    }
    
    func test_multipleMatchesFailure() {
        assertFails(
            description: """
                Проверка не прошла (отображается "multipleMatchesFailureView") - найдено несколько элементов по заданным критериям
                """)
        {
            pageObjects.screen.multipleMatchesFailureView.withTimeout(1).assert.isDisplayed()
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    var multipleMatchesFailureView: ViewElement {
        return element("multipleMatchesFailureView") {
            $0.id == "multipleMatchesFailureView"
        }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
