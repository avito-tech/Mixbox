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

        // x and y have to be rounded because CGImage.cropping doesn't handle
        let frameForCropping = CGRect(
            x: (elementShanpshot.frameOnScreen.origin.x * image.scale).rounded(.down),
            y: (elementShanpshot.frameOnScreen.origin.y * image.scale).rounded(.up),
            width: elementShanpshot.frameOnScreen.size.width * image.scale,
            height: elementShanpshot.frameOnScreen.size.height * image.scale
        )

        guard let croppedCgImage = cgImage.cropping(to: frameForCropping) else {
            return nil
        }

        let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)

        return croppedImage
    }
}
