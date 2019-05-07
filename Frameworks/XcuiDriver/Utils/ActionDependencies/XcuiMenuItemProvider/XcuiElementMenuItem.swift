import MixboxUiTestsFoundation
import MixboxFoundation
import XCTest

public final class XcuiElementMenuItem: MenuItem {
    private let xcuiElement: XCUIElement
    
    public init(xcuiElement: XCUIElement) {
        self.xcuiElement = xcuiElement
    }
    
    public func tap() throws {
        guard xcuiElement.exists else {
            throw ErrorString("Element doesn't exist")
        }
        xcuiElement.tap()
    }
    
    public func waitForExistence(timeout: TimeInterval) throws {
        if !xcuiElement.exists {
            if !xcuiElement.waitForExistence(timeout: timeout) {
                throw ErrorString("Timed out waiting element for existence")
            }
        }
    }
}
