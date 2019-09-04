import MixboxTestsFoundation
import Photos
import XCTest

final class PhotoStubberTests: TestCase {
    // TODO: Fix running on CI
    func test() {
        setUpPhotosPermissions()
        
        removeAllImagesFromSimulator()
        
        // count == 0: Check if previous code drops the state
        // count == 10, 20, 30: Actual test
        for count in [0, 100, 200, 300] {
            stubPhotos(minimalCount: count)
            XCTAssertEqual(photosCount(), count)
        }
        
        // If we require minimalCount of photos we don't want to delete exisitng photos
        stubPhotos(minimalCount: 200)
        XCTAssertEqual(photosCount(), 300)
        
        // Check again if this test drops state correctly.
        // There was a situation when I was running test twice. The following lines are to not run test twice.
        removeAllImagesFromSimulator()
        XCTAssertEqual(photosCount(), 0)
        
        stubPhotos(minimalCount: 200)
        XCTAssertEqual(photosCount(), 200)
    }
    
    private func stubPhotos(minimalCount: Int) {
        do {
            try photoStubber.stubPhotos(minimalCount: minimalCount)
        } catch {
            XCTFail("Failed to stub photos: \(error)")
        }
    }
    
    private func setUpPhotosPermissions() {
        // TODO: Move optimization to PermissionSetter?
        // Note that it is only valid for current process, so it is not generic.
        
        testRunnerPermissions.photos.set(.allowed)
        
        waiter.wait(
            timeout: 30,
            interval: 1,
            until: {
                PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
            }
        )
    }
    
    private func photosCount() -> Int {
        return PHAsset.fetchAssets(with: .image, options: PHFetchOptions()).count
    }
    
    private func removeAllImagesFromSimulator() {
        var thereArePhotosToDelete: Bool?
        var deletionCompleted: Bool = false
        
        PHPhotoLibrary.shared().performChanges(
            {
                let allPhotos = PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
                // swiftlint:disable:next empty_count
                thereArePhotosToDelete = allPhotos.count > 0
                PHAssetChangeRequest.deleteAssets(allPhotos)
            }, completionHandler: { _, error in
                deletionCompleted = true
                
                if let error = error {
                    XCTFail("Error while deleting photos: \(error)")
                }
            }
        )
        
        waiter.wait(
            timeout: 60,
            interval: 0.1,
            until: {
                thereArePhotosToDelete != nil
            }
        )
        
        if let thereArePhotosToDelete = thereArePhotosToDelete {
            if thereArePhotosToDelete {
                allowDeletingPhotos()
            }
        }
        
        waiter.wait(
            timeout: 60,
            interval: 0.1,
            until: {
                deletionCompleted
            }
        )
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
            
            waiter.wait(
                timeout: 5,
                interval: 1,
                until: { [weak self] in
                    if deleteButton.exists {
                        return false
                    } else if let strongSelf = self {
                        return strongSelf.photosCount() == 0
                    } else {
                        return true
                    }
                }
            )
        } else {
            XCTFail("Delete button did not appear")
        }
    }
}
