import MixboxFoundation

public final class StubbedImagesProvider: ImagesProvider {
    private let imageProviders: [ImageProvider]
    
    public init(
        imageProviders: [ImageProvider])
    {
        self.imageProviders = imageProviders
    }
    
    public func images() throws -> [ImageProvider] {
        return imageProviders
    }
}
