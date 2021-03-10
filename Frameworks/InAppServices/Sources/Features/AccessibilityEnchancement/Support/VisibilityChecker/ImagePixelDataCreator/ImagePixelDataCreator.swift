#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ImagePixelDataFromImageCreator {
    func createImagePixelData(
        image: CGImage)
        throws
        -> ImagePixelData
}

#endif
