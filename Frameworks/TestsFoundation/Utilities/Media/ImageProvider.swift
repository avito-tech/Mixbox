import MixboxFoundation

public protocol ImageProvider {
    var image: DataResult<UIImage, String> { get }
}

public final class LazyImageProvider: ImageProvider {
    public private(set) lazy var image: DataResult<UIImage, String> = self.makeImage()
    private let imagePath: String
    
    public init(imagePath: String) {
        self.imagePath = imagePath
    }
    
    private func makeImage() -> DataResult<UIImage, String> {
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return .error("Failed to UIImage(contentsOfFile: \(imagePath))")
        }
        
        return .data(image)
    }
}
