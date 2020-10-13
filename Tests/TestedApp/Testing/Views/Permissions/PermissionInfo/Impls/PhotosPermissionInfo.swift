import Photos

final class PhotosPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "photos"
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    func authorizationStatus() -> String {
        let status = PHPhotoLibrary.authorizationStatus()
        
        #if compiler(>=5.3)
        // Xcode 12+
        switch status {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .limited:
            return "limited"
        @unknown default:
            return "UNKNOWN: \(status)"
        }
        #else
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
        #endif
    }
}
