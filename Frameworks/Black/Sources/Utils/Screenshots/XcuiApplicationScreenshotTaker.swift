import MixboxUiTestsFoundation
import XCTest
import MixboxFoundation

public final class XcuiApplicationScreenshotTaker: ApplicationScreenshotTaker {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func takeApplicationScreenshot() throws -> UIImage {
        let application = applicationProvider.application
        
        guard let screenshot = applicationProvider.application.screenshot() else {
            throw ErrorString("Failed to get screenshot from application. Application: \(application).")
        }
        
        guard let xcuiScreenshot = screenshot as? XCUIScreenshot else {
            throw ErrorString("Failed to convert screenshot to XCUIScreenshot. Actual screenshot type: \(type(of: screenshot)).")
        }
        
        return xcuiScreenshot.image
    }
}
