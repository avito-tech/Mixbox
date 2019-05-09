import MixboxTestsFoundation

final class RedImagesProvider: ImagesProvider {
    private lazy var lazyImagesProvider: ImagesProvider = SortedImagesProvider(
        path: self.makeFolderWithStubImages(count: 10),
        imageProviderFactory: { LazyImageProvider(imagePath: $0) }
    )
    
    func images() throws -> [ImageProvider] {
        return try lazyImagesProvider.images()
    }
    
    private func makeFolderWithStubImages(count: Int) -> String {
        let temporaryDirectory = NSTemporaryDirectory()
        
        for index in 0..<count {
            guard let image = randomImage() else {
                XCTFail("Failed to create randomImage()")
                continue
            }
            guard let data = UIImagePNGRepresentation(image) else {
                XCTFail("Fail at UIImagePNGRepresentation")
                continue
            }
            
            let filename = temporaryDirectory.mb_appendingPathComponent("\(index).png")
            do {
                try data.write(to: URL(fileURLWithPath: filename))
            } catch {
                XCTFail("Fail at data.write(to: \(filename)): \(error)")
            }
        }
        
        return temporaryDirectory
    }
    
    private func randomImage() -> UIImage? {
        return UIImage.image(color: .red, size: CGSize(width: 1, height: 1))
    }
}
