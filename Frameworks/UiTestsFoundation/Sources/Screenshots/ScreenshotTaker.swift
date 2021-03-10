import UIKit

public protocol ScreenshotTaker: class {
    func takeScreenshot() -> UIImage?
}

extension ScreenshotTaker {
    public func elementImage(elementShanpshot: ElementSnapshot) -> UIImage? {
        guard
            let image = takeScreenshot(),
            let cgImage = image.cgImage else {
            return nil
        }

        let frameForCropping = CGRect(
            x: elementShanpshot.frameRelativeToScreen.origin.x * image.scale,
            y: elementShanpshot.frameRelativeToScreen.origin.y * image.scale,
            width: elementShanpshot.frameRelativeToScreen.size.width * image.scale,
            height: elementShanpshot.frameRelativeToScreen.size.height * image.scale
        )

        guard let croppedCgImage = cgImage.cropping(to: frameForCropping) else {
            return nil
        }

        let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)

        return croppedImage
    }
}
