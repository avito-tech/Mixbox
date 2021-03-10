#if MIXBOX_ENABLE_IN_APP_SERVICES

public protocol ImageFromImagePixelDataCreator {
    func image(
        imagePixelData: ImagePixelData,
        scale: CGFloat,
        orientation: UIImage.Orientation)
        throws
        -> UIImage
}

#endif
