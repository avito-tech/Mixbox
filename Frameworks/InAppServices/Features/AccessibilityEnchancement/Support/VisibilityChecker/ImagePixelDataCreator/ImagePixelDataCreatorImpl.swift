#if MIXBOX_ENABLE_IN_APP_SERVICES

import MixboxFoundation

public final class ImagePixelDataCreatorImpl: ImagePixelDataCreator {
    private let bytesPerPixel = 4
    
    public init() {
    }
    
    public func createImagePixelData(
        image: CGImage)
        throws
        -> ImagePixelData
    {
        let width = image.width
        let height = image.height
        let imagePixelBuffer = UnsafeArray<UInt8>(count: height * width * bytesPerPixel)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Create the bitmap context. We want XRGB.
        let bitmapContextOrNil = CGContext(
            data: imagePixelBuffer.pointer,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * bytesPerPixel,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )
        
        guard let bitmapContext = bitmapContextOrNil else {
            throw ErrorString("Failed to create CGContext")
        }

        // Once we draw, the memory allocated for the context for rendering will then contain the raw
        // image pixel data in the specified color space.
        bitmapContext.draw(
            image,
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )
        
        return ImagePixelData(imagePixelBuffer: imagePixelBuffer, bitmapContext: bitmapContext)
    }
}

#endif
