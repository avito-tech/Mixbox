import Photos

final class GeolocationPermissionInfo: PermissionInfo {
    func identifier() -> String {
        return "geolocation"
    }
    
    func authorizationStatus() -> String {
        switch CLLocationManager.authorizationStatus() {
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
        }
    }
}


