import XCTest
import MixboxUiTestsFoundation

public final class XcuiElementElementSimpleGestures: ElementSimpleGestures {
    private let xcuiElement: XCUIElement
    
    public init(xcuiElement: XCUIElement) {
        self.xcuiElement = xcuiElement
    }
    
    public func tap() {
        xcuiElement.tap()
    }
    
    public func doubleTap() {
        xcuiElement.tap()
    }
    
    public func press(duration: TimeInterval) {
        xcuiElement.press(forDuration: duration)
    }
}
