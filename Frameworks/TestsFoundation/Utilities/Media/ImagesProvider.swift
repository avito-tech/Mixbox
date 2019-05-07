import MixboxFoundation

public protocol ImagesProvider {
    var images: DataResult<[ImageProvider], String> { get }
}

public final class SortedImagesProvider: ImagesProvider {
    public private(set) lazy var images: DataResult<[ImageProvider], String> = self.makeImages()
    
    private let path: String
    private let imageProviderFactory: (String) -> (ImageProvider)
    
    public init(path: String, imageProviderFactory: @escaping (String) -> (ImageProvider)) {
        self.path = path
        self.imageProviderFactory = imageProviderFactory
    }
    
    private func makeImages() -> DataResult<[ImageProvider], String> {
        do {
            let sourcePhotos = try FileManager.default.contentsOfDirectory(atPath: path).sorted().map {
                path.mb_appendingPathComponent($0)
            }
            return .data(sourcePhotos.map { imageProviderFactory($0) })
        } catch {
            return .error("Failed to FileManager.default.contentsOfDirectory(atPath: \(path)): \(error)")
        }
    }
}
