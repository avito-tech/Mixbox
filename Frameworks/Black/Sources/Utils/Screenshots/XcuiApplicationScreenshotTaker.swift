import MixboxUiTestsFoundation
import XCTest
import MixboxFoundation

public final class XcuiApplicationScreenshotTaker: ApplicationScreenshotTaker {
    private let applicationProvider: ApplicationProvider
    
    public init(applicationProvider: ApplicationProvider) {
        self.applicationProvider = applicationProvider
    }
    
    public func takeApplicationScreenshot() throws -> UIImage {
        let screenshot = applicationProvider.application.screenshot()
        
        return screenshot.image
    }
}
