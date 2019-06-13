import MixboxTestsFoundation
import MixboxFoundation

final class RedImagesProvider: ImagesProvider, ImagesProviderHolder {
    let imagesProvider: ImagesProvider
    
    init() {
        imagesProvider = StubbedImagesProvider(
            imageProviders: (0..<10).compactMap { _ in
                RedImagesProvider.imageProvider()
            }
        )
    }
    
    private static func imageProvider() -> ImageProvider {
        if let image = randomImage() {
            return StubbedImageProvider(
                image: image
            )
        } else {
            return StubbedImageProvider(
                error: ErrorString("Couldn't create randomImage")
            )
        }
    }
    
    private static func randomImage() -> UIImage? {
        return UIImage.image(color: .red, size: CGSize(width: 1, height: 1))
    }
}
