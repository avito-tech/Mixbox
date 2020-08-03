import XCTest

class GrayBoxTests: TestCase {
    func test() {
        pageObjects.firstScreen.label.assertHasText("Label")
        pageObjects.firstScreen.button.tap()
        
        pageObjects.secondScreen.otherLabel.assertHasText("Other Label")
    }
}
