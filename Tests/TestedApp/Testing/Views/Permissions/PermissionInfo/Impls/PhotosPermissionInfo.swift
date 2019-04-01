import Photos

final class PhotosPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "photos"
    }
    
    func authorizationStatus() -> String {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        }
    }
}
