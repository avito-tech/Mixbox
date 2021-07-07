import UIKit

public protocol ApplicationScreenshotTaker: AnyObject {
    func takeApplicationScreenshot() throws -> UIImage
}
