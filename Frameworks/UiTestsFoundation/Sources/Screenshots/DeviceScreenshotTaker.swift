import UIKit

public protocol DeviceScreenshotTaker: AnyObject {
    func takeDeviceScreenshot() throws -> UIImage
}
