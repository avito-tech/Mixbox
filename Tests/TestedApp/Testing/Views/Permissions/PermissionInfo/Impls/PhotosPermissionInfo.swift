import Photos

final class PhotosPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "photos"
    }
    
    func authorizationStatus() -> String {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        @unknown default:
            return "UNKNOWN: \(status)"
        }
    }
}
