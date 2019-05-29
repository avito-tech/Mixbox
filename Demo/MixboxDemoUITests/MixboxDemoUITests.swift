import XCTest

class DemoTests: TestCase {
    func test() {
        launch()
        
        pageObjects.firstScreen.label.assertHasText("Label")
        pageObjects.firstScreen.button.tap()
        
        pageObjects.secondScreen.otherLabel.assertHasText("Other Label")
    }
}
