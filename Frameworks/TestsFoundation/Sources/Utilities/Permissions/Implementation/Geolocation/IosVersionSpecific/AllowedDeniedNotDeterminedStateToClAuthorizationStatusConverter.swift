import CoreLocation

final class AllowedDeniedNotDeterminedStateToClAuthorizationStatusConverter {
    func clAuthorizationStatus(state: AllowedDeniedNotDeterminedState) -> CLAuthorizationStatus {
        switch state {
        case .allowed:
            return .authorizedWhenInUse
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        }
    }
}
