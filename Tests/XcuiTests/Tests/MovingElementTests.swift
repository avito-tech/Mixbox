import MixboxUiTestsFoundation
import XCTest

final class MovingElementTests: TestCase {
    override func precondition() {
        openScreen(name: "MovingElementTestsView")
    }
    
    // TODO: Add assertions,
    // make it able to hit moving element.
    func test() {
        for _ in 0..<10 {
            pageObjects.xcui.movingElement.tap()
        }
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    var movingElement: ViewElement {
        return element("movingElement") {
            $0.id == "movingElement"
        }
    }
}

private extension PageObjects {
    var real: Screen {
        return apps.mainRealHierarchy.pageObject()
    }
    var xcui: Screen {
        return apps.mainXcui.pageObject()
    }
}
