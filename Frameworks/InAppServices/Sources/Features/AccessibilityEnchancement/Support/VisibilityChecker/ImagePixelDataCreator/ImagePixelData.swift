#if MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES && MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES
#error("InAppServices is marked as both enabled and disabled, choose one of the flags")
#elseif MIXBOX_DISABLE_FRAMEWORK_IN_APP_SERVICES || (!MIXBOX_ENABLE_ALL_FRAMEWORKS && !MIXBOX_ENABLE_FRAMEWORK_IN_APP_SERVICES)
// The compilation is disabled
#else

public final class ImagePixelData {
    public let imagePixelBuffer: UnsafeArray<UInt8>
    public let bytesPerPixel: Int
    public let size: IntSize
    
    public init(
        imagePixelBuffer: UnsafeArray<UInt8>,
        bytesPerPixel: Int,
        size: IntSize)
    {
        self.imagePixelBuffer = imagePixelBuffer
        self.bytesPerPixel = bytesPerPixel
        self.size = size
    }
    
    public func cropped(rect: IntRect) -> ImagePixelData {
        let targetSize = rect.size
        let targetSizeInBytes = size.area * bytesPerPixel
        
        let target = ImagePixelData(
            imagePixelBuffer: UnsafeArray<UInt8>(count: targetSizeInBytes),
            bytesPerPixel: bytesPerPixel,
            size: targetSize
        )
        
        for sourceY in rect.minY..<rect.maxY {
            let targetY = sourceY - rect.minY
            let sourceWidthInBytes = size.width * bytesPerPixel
            let targetWidthInBytes = targetSize.width * bytesPerPixel
            
            let sourceOffset = sourceY * sourceWidthInBytes + rect.minX * bytesPerPixel
            let targetOffset = targetY * targetWidthInBytes
            
            memcpy(
                target.imagePixelBuffer.pointer.advanced(by: targetOffset),
                imagePixelBuffer.pointer.advanced(by: sourceOffset),
                targetWidthInBytes
            )
        }
        
        return target
    }
    
    @inlinable
    public func copy() -> ImagePixelData {
        return ImagePixelData(
            imagePixelBuffer: imagePixelBuffer.copy(),
            bytesPerPixel: bytesPerPixel,
            size: size
        )
    }
}

#endif
