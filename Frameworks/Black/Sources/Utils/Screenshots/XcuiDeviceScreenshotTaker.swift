import MixboxUiTestsFoundation
import XCTest

public final class XcuiDeviceScreenshotTaker: DeviceScreenshotTaker {
    public init() {
    }
    
    public func takeDeviceScreenshot() throws -> UIImage {
        return XCUIScreen.main.screenshot().image
    }
}
