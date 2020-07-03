#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ImagePixelDataCreator {
    func createImagePixelData(
        image: CGImage)
        throws
        -> ImagePixelData
}

#endif
