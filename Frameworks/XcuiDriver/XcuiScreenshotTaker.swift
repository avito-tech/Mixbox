import MixboxUiTestsFoundation
import XCTest

public final class XcuiScreenshotTaker: ScreenshotTaker {
    public init() {
    }
    
    public func takeScreenshot() -> UIImage? {
        return XCUIScreen.main.screenshot().image
    }
}
