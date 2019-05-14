import MixboxFoundation
import MixboxReporting
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
                    range: existingPhotosCount..<minimalCount,
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
    
    private func stubPhotos(range: CountableRange<Int>, images: [ImageProvider]) throws {
        guard !images.isEmpty else {
            throw ErrorString("No photos to stub")
        }
        
        let dispatchGroup = DispatchGroup()
        
        var errors = [ErrorString]()
        
        for index in range {
            let image = try images[index % images.count].image()
            
            dispatchGroup.enter()
            photoSaver.save(image: image) { result in
                result.onError { errors.append($0) }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        
        if !errors.isEmpty {
            throw ErrorString("Saving photos completed with errors: \(errors)")
        }
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
