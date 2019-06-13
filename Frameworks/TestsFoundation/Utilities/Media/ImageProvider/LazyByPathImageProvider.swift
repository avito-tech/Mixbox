import MixboxFoundation

public final class LazyByPathImageProvider: ImageProvider {
    public private(set) lazy var lazyImage: DataResult<UIImage, ErrorString> = self.makeImage()
    private let imagePath: String
    
    public init(imagePath: String) {
        self.imagePath = imagePath
    }
    
    public func image() throws -> UIImage {
        switch lazyImage {
        case .data(let image):
            return image
        case .error(let error):
            throw error
        }
    }
    
    private func makeImage() -> DataResult<UIImage, ErrorString> {
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return .error(ErrorString("Failed to UIImage(contentsOfFile: \(imagePath))"))
        }
        
        return .data(image)
    }
}
