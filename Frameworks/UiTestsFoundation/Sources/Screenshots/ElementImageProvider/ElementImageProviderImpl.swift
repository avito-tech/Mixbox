import UIKit
import MixboxFoundation
import MixboxUiKit

public final class ElementImageProviderImpl: ElementImageProvider {
    private let screenshotTaker: ApplicationScreenshotTaker
    private let applicationFrameProvider: ApplicationFrameProvider
    
    public init(
        screenshotTaker: ApplicationScreenshotTaker,
        applicationFrameProvider: ApplicationFrameProvider)
    {
        self.screenshotTaker = screenshotTaker
        self.applicationFrameProvider = applicationFrameProvider
    }
    
    public func elementImage(
        elementShanpshot: ElementSnapshot)
        throws
        -> UIImage
    {
        let image = try screenshotTaker.takeApplicationScreenshot()
        
        guard let cgImage = image.cgImage else {
            throw ErrorString("Failed to get cgImage from screenshot")
        }
        
        // Not supported! There may be possible problems in apps that
        // are not in fullscreen (iPad, for example).
        let offset: CGVector = .zero
        let imageSize: CGSize = image.size * image.scale
        let scale: CGVector = imageSize / applicationFrameProvider.applicationFrame.size

        let frameForCropping = CGRect(
            origin: offset + elementShanpshot.frameRelativeToScreen.origin * scale,
            size: offset + elementShanpshot.frameRelativeToScreen.size * scale
        )

        guard let croppedCgImage = cgImage.cropping(to: frameForCropping) else {
            throw ErrorString(
                """
                Cropping screenshot to element's frame resulted in `nil` image.
                
                This can occur if image and rect don't intersect.
                
                Image size: \(image.size)
                Image scale: \(image.scale)
                Frame for cropping: \(frameForCropping)
                """
            )
        }

        let croppedImage = UIImage(cgImage: croppedCgImage, scale: image.scale, orientation: image.imageOrientation)

        return croppedImage
    }
}
