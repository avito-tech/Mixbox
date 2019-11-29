import Photos

final class GeolocationPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "geolocation"
    }
    
    func authorizationStatus() -> String {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
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
