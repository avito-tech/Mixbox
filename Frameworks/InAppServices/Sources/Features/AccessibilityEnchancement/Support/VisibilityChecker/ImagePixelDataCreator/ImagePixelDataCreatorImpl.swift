#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

import MixboxFoundation

public final class ImagePixelDataFromImageCreatorImpl: ImagePixelDataFromImageCreator {
    private let bytesPerPixel = 4
    
    public init() {
    }
    
    public func createImagePixelData(
        image: CGImage)
        throws
        -> ImagePixelData
    {
        let size = image.size
        let imagePixelBuffer = UnsafeArray<UInt8>(count: size.area * bytesPerPixel)

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        // Create the bitmap context. We want XRGB.
        let bitmapContextOrNil = CGContext(
            data: imagePixelBuffer.pointer,
            width: size.width,
            height: size.height,
            bitsPerComponent: 8,
            bytesPerRow: size.width * bytesPerPixel,
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
                width: size.width,
                height: size.height
            )
        )
        
        return ImagePixelData(
            imagePixelBuffer: imagePixelBuffer,
            bytesPerPixel: bytesPerPixel,
            size: size
        )
    }
}

#endif
