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
            
            #if compiler(>=5.3)
            // Xcode 12+
            
        case .limited:
            return "limited"
            
            #endif
        @unknown default:
            return "UNKNOWN: \(status)"
        }
    }
}
