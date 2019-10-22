import MixboxUiTestsFoundation
import XCTest

final class CanTapMovingElementTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(name: "MovingElementTestsView")
    }
    
    // TODO: Add assertions,
    // make it able to hit moving element.
    func disabled_test() {
        for _ in 0..<10 {
            pageObjects.screen.movingElement.tap()
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
    var screen: Screen {
        return apps.mainDefaultHierarchy.pageObject()
    }
}
