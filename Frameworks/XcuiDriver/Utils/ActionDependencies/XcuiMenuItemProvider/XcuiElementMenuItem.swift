import MixboxUiTestsFoundation
import XCTest

public final class XcuiElementMenuItem: MenuItem {
    private let xcuiElement: XCUIElement
    
    public init(xcuiElement: XCUIElement) {
        self.xcuiElement = xcuiElement
    }
    
    public func tap() {
        xcuiElement.tap()
    }
    
    public func waitForExistence(timeout: TimeInterval) -> Bool {
        return xcuiElement.waitForExistence(timeout: timeout)
    }
}
