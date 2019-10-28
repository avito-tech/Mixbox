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
        do {
            return StubbedImageProvider(
                image: try randomImage()
            )
        } catch {
            return StubbedImageProvider(
                error: error
            )
        }
    }
    
    private static func randomImage() throws -> UIImage {
        return try UIImage.image(
            color: .red,
            size: CGSize(width: 1, height: 1)
        )
    }
}
