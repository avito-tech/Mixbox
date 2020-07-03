#if MIXBOX_ENABLE_IN_APP_SERVICES

public final class ImagePixelData {
    public let imagePixelBuffer: UnsafeArray<UInt8>
    public let bitmapContext: CGContext
    
    public init(
        imagePixelBuffer: UnsafeArray<UInt8>,
        bitmapContext: CGContext)
    {
        self.imagePixelBuffer = imagePixelBuffer
        self.bitmapContext = bitmapContext
    }
}

#endif
