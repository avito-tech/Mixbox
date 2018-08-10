import XCTest

class DemoTests: TestCase {
    func test() {
        launch()
        
        pageObjects.firstScreen.label.assert.hasText("Label")
        pageObjects.firstScreen.button.tap()
        
        pageObjects.secondScreen.otherLabel.assert.hasText("Other Label")
    }
}
