import MixboxFoundation
import Photos

public protocol PhotoStubber {
    func stubPhotos(minimalCount: Int) -> DataResult<Void, String>
}

public final class PhotoStubberImpl: PhotoStubber {
    private let stubImagesProvider: ImagesProvider
    private let photoSaver = PhotoSaver()
    
    public init(stubImagesProvider: ImagesProvider) {
        self.stubImagesProvider = stubImagesProvider
    }
    
    public func stubPhotos(minimalCount: Int) -> DataResult<Void, String> {
        return setUpGalleryPermissions().flatMapData { _ in
            let existingPhotosCount = self.existingPhotosCount()
            
            if minimalCount > existingPhotosCount {
                return stubImagesProvider.images.flatMapData { images in
                    stubPhotos(
                        range: existingPhotosCount..<minimalCount,
                        images: images
                    )
                }
            }
            
            return .data(())
        }
    }
    
    private func setUpGalleryPermissions() -> DataResult<Void, String> {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            guard let bundleId = Bundle.main.bundleIdentifier else {
                return .error("Can not get bundleId")
            }
            
            guard TccPrivacySettingsManager(bundleId: bundleId).updatePrivacySettings(service: .photos, state: .allowed) else {
                return .error("Can not update privacy settings")
            }
        }
        
        return .data(())
    }
    
    private func stubPhotos(range: CountableRange<Int>, images: [ImageProvider]) -> DataResult<Void, String> {
        guard images.count > 0 else {
            return .error("No photos to stub")
        }
        
        let dispatchGroup = DispatchGroup()
        
        for index in range {
            let result = images[index % images.count].image.mapData { image in
                save(image: image, dispatchGroup: dispatchGroup)
            }
            if let error = result.error {
                return .error(error)
            }
        }
        
        dispatchGroup.wait()
        
        return .data(())
    }
    
    private func save(image: UIImage, dispatchGroup: DispatchGroup) -> DataResult<(), String> {
        return photoSaver.save(image: image)
    }
    
    private func existingPhotosCount() -> Int {
        return PHAsset.fetchAssets(with: .image, options: PHFetchOptions()).count
    }
}
