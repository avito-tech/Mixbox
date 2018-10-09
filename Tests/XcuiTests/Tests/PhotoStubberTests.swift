import MixboxTestsFoundation
import Photos
import XCTest

final class PhotoStubberTests: TestCase {
    private lazy var stubber = PhotoStubberImpl(
        stubImagesProvider: SortedImagesProvider(
            path: self.makeFolderWithStubImages(count: 10),
            imageProviderFactory: { LazyImageProvider(imagePath: $0) }
        )
    )
    
    func test() {
        setUpPhotosPermissions()
        
        removeAllImagesFromSimulator()
        
        // count == 0: Check if previous code drops the state
        // count == 10, 20, 30: Actual test
        for count in [0, 10, 20, 30] {
            stubPhotos(minimalCount: count)
            XCTAssertEqual(photosCount(), count)
        }
        
        // If we require minimalCount of photos we don't want to delete exisitng photos
        stubPhotos(minimalCount: 20)
        XCTAssertEqual(photosCount(), 30)
        
        // Check again if this test drops state correctly.
        // There was a situation when I was running test twice. The following lines are to not run test twice.
        removeAllImagesFromSimulator()
        XCTAssertEqual(photosCount(), 0)
        
        stubPhotos(minimalCount: 20)
        XCTAssertEqual(photosCount(), 20)
    }
    
    private func stubPhotos(minimalCount: Int) {
        stubber.stubPhotos(minimalCount: minimalCount).onError { message in
            XCTFail("Failed to stub photos: \(message)")
        }
    }
    
    private func setUpPhotosPermissions() {
        // TODO: Move optimization to PermissionSetter?
        // Note that it is only valid for current process, so it is not generic.
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            testRunnerPermissions.photos.set(.allowed)
        }
    }
    
    private func photosCount() -> Int {
        return PHAsset.fetchAssets(with: .image, options: PHFetchOptions()).count
    }
    
    private func removeAllImagesFromSimulator() {
        var thereArePhotosToDelete: Bool?
        PHPhotoLibrary.shared().performChanges(
            {
                let allPhotos = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
                thereArePhotosToDelete = allPhotos.count > 0
                PHAssetChangeRequest.deleteAssets(allPhotos)
            }, completionHandler: { _, error in
                if let error = error {
                    XCTFail("Error while deleting photos: \(error)")
                }
            }
        )
        
        while thereArePhotosToDelete == nil {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        
        if let thereArePhotosToDelete = thereArePhotosToDelete {
            if thereArePhotosToDelete {
                allowDeletingPhotos()
            }
        }
    }
    
    private func allowDeletingPhotos() {
        guard let springboard = XCUIApplication(privateWithPath: nil, bundleID: "com.apple.springboard") else {
            XCTFail("Couldn't find springboard app")
            return
        }
        
        let deleteButton = springboard.buttons.element(
            matching: NSPredicate(
                format: "label = 'Удалить' or label = 'Delete'",
                argumentArray: []
            )
        )
        
        if deleteButton.waitForExistence(timeout: 15) {
            deleteButton.tap()
            
            for _ in 0..<5 {
                if deleteButton.exists || photosCount() > 0 {
                    Thread.sleep(forTimeInterval: 1)
                } else {
                    break
                }
            }
        } else {
            XCTFail("Delete button did not appear")
        }
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
            } catch let error {
                XCTFail("Fail at data.write(to: \(filename)): \(error)")
            }
        }
        
        return temporaryDirectory
    }
    
    private func randomImage() -> UIImage? {
        return UIImage.image(color: .red, size: CGSize(width: 1, height: 1))
    }
}
