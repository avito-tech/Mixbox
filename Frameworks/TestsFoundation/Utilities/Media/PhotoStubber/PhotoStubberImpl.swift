import MixboxFoundation
import MixboxTestsFoundation
import Photos

public final class PhotoStubberImpl: PhotoStubber {
    private let tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory
    private let stubImagesProvider: ImagesProvider
    private let photoSaver: PhotoSaver
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        stubImagesProvider: ImagesProvider,
        tccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory,
        photoSaver: PhotoSaver,
        testFailureRecorder: TestFailureRecorder)
    {
        self.stubImagesProvider = stubImagesProvider
        self.tccDbApplicationPermissionSetterFactory = tccDbApplicationPermissionSetterFactory
        self.photoSaver = photoSaver
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func stubPhotos(minimalCount: Int) {
        do {
            try stubPhotosOrThrowError(minimalCount: minimalCount)
        } catch {
            testFailureRecorder.recordFailure(
                description: "\(error)",
                shouldContinueTest: false
            )
        }
    }
    
    private func stubPhotosOrThrowError(minimalCount: Int) throws {
        do {
            try setUpGalleryPermissions()
            
            let existingPhotosCount = self.existingPhotosCount()
            
            if minimalCount > existingPhotosCount {
                let images = try stubImagesProvider.images()
                
                try stubPhotos(
                    count: minimalCount - existingPhotosCount,
                    images: images
                )
            }
        } catch {
            throw ErrorString("Failed to stub photos: \(error)")
        }
    }
    
    private func setUpGalleryPermissions() throws {
        do {
            if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
                try setUpPermissions()
            }
        } catch {
            throw ErrorString("Failed to setUpGalleryPermissions: \(error)")
        }
    }
    
    private func stubPhotos(count: Int, images: [ImageProvider]) throws {
        try photoSaver.save(
            imagesProvider: PhotoStubberImagesProvider(
                count: count,
                imageProviders: images
            )
        )
    }
    
    private func existingPhotosCount() -> Int {
        return PHAsset.fetchAssets(with: .image, options: PHFetchOptions()).count
    }
    
    private func setUpPermissions() throws {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            throw ErrorString("Failed to get bundleId")
        }
        
        let setter = tccDbApplicationPermissionSetterFactory.tccDbApplicationPermissionSetter(
            service: .photos,
            bundleId: bundleId,
            testFailureRecorder: testFailureRecorder
        )
        
        setter.set(.allowed)
    }
}

private class PhotoStubberImagesProvider: ImagesProvider {
    private let count: Int
    private let imageProviders: [ImageProvider]
    
    init(
        count: Int,
        imageProviders: [ImageProvider])
    {
        self.count = count
        self.imageProviders = imageProviders
    }
    
    func images() throws -> [ImageProvider] {
        // swiftlint:disable:next empty_count
        if count == 0 {
            return []
        } else {
            return (0..<count).map { index in
                imageProviders[index % imageProviders.count]
            }
        }
    }
}
