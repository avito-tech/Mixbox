import MixboxFoundation

public final class LazyBundledImageProvider: ImageProvider {
    public private(set) lazy var lazyImage: DataResult<UIImage, ErrorString> = self.makeImage()
    private let bundle: Bundle
    private let resourceName: String
    
    public init(
        bundle: Bundle,
        resourceName: String)
    {
        self.bundle = bundle
        self.resourceName = resourceName
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
        guard let image = UIImage(named: resourceName, in: bundle, compatibleWith: nil) else {
            return .error(ErrorString("Failed to UIImage(named: \"\(resourceName)\", in: \(bundle), compatibleWith: nil)"))
        }
        
        return .data(image)
    }
}
