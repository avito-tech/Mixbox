#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class ImageFromImagePixelDataCreatorImpl: ImageFromImagePixelDataCreator {
    public init() {
    }
    
    public func image(
        imagePixelData pixelData: ImagePixelData,
        scale: CGFloat,
        orientation: UIImage.Orientation)
        throws
        -> UIImage
    {
        let width = pixelData.size.width
        let height = pixelData.size.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapContextOrNil = CGContext(
            data: pixelData.imagePixelBuffer.pointer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: pixelData.bytesPerPixel * width,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGImageByteOrderInfo.order32Big.rawValue
        )
        
        guard let bitmapContext = bitmapContextOrNil else {
            throw ErrorString("Failed to create CGContext")
        }
        
        guard let bitmapImage = bitmapContext.makeImage() else {
            throw ErrorString("Failed to makeImage() from CGContext")
        }
        
        return UIImage(
            cgImage: bitmapImage,
            scale: scale,
            orientation: orientation
        )
    }
}

#endif
