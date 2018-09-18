import MixboxFoundation

public final class GeolocationApplicationPermissionSetter: ApplicationPermissionSetter {
    private let bundleId: String
    
    public init(bundleId: String) {
        self.bundleId = bundleId
    }
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        let authorizationStatus = clAuthorizationStatus(state: state)
        CLLocationManager.setAuthorizationStatusByType(authorizationStatus, forBundleIdentifier: bundleId)
        CLLocationManager.shutdownDaemon()
    }
    
    private func clAuthorizationStatus(state: AllowedDeniedNotDeterminedState) -> CLAuthorizationStatus {
        switch state {
        case .allowed:
            return .authorizedAlways
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        }
    }
}
