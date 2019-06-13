import MixboxFoundation

public final class StubbedImageProvider: ImageProvider {
    public enum StubbedResult {
        case image(UIImage)
        case error(Error)
    }
    
    private let stubbedResult: StubbedResult
    
    public init(stubbedResult: StubbedResult) {
        self.stubbedResult = stubbedResult
    }
    
    public convenience init(image: UIImage) {
        self.init(
            stubbedResult: .image(image)
        )
    }
    
    public convenience init(error: Error) {
        self.init(
            stubbedResult: .error(error)
        )
    }
    
    public func image() throws -> UIImage {
        switch stubbedResult {
        case .error(let error):
            throw error
        case .image(let image):
            return image
        }
    }
}
