import XCTest

class AppForCheckingPureXctestUITests: XCTestCase {
    func testExample() {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssert(app.otherElements["view"].exists)
        XCTAssertEqual(app.otherElements["view"].label, "view.accessibilityLabel")
        XCTAssertEqual(app.otherElements["view"].value as? String, "view.accessibilityValue")
        XCTAssert(app.buttons["button"].exists)
        XCTAssertEqual(app.buttons["button"].label, "button.title.normal")
        XCTAssert(app.staticTexts["label"].exists)
        XCTAssertEqual(app.staticTexts["label"].label, "label.text")
        XCTAssert(app.textViews["textView"].exists)
        XCTAssertEqual(app.textViews["textView"].value as? String, "textView.text")
        XCTAssert(app.textFields["textField"].exists)
        XCTAssertEqual(app.textFields["textField"].value as? String, "textField.text")
    }
}
