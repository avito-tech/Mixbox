import XCTest
import MixboxUiTestsFoundation

public final class XcuiCoordinateElementSimpleGestures: ElementSimpleGestures {
    private let xcuiCoordinate: XCUICoordinate
    
    public init(xcuiCoordinate: XCUICoordinate) {
        self.xcuiCoordinate = xcuiCoordinate
    }
    
    public func tap() {
        xcuiCoordinate.tap()
    }
    
    public func press(duration: TimeInterval) throws {
        xcuiCoordinate.press(forDuration: duration)
    }
    
    public func press(duration: TimeInterval, thenDragToCoordinate: XCUICoordinate) {
        xcuiCoordinate.press(forDuration: duration, thenDragTo: thenDragToCoordinate)
    }
}
