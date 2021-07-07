import UIKit
import MixboxInAppServices
import MixboxUiTestsFoundation

public final class GrayScreenshotTaker: DeviceScreenshotTaker, ApplicationScreenshotTaker {
    private let inAppScreenshotTaker: InAppScreenshotTaker
    
    public init(
        inAppScreenshotTaker: InAppScreenshotTaker)
    {
        self.inAppScreenshotTaker = inAppScreenshotTaker
    }
    
    public func takeApplicationScreenshot() throws -> UIImage {
        return try inAppScreenshotTaker.takeScreenshot(afterScreenUpdates: true)
    }
    
    // Not really a device screenshot, but will suit our needs.
    public func takeDeviceScreenshot() throws -> UIImage {
        return try takeApplicationScreenshot()
    }
}
