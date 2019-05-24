import MixboxTestsFoundation

final class GeolocationApplicationPermissionSpecification:
    ApplicationPermissionWithAllowedDeniedNotDeterminedStateSpecification
{
    var identifier: String {
        return "geolocation"
    }
    
    func setter(permissions: ApplicationPermissionsSetter) -> ApplicationPermissionSetter {
        return permissions.geolocation
    }
    
    func authorizationStatusString(state: AllowedDeniedNotDeterminedState) -> String {
        switch state {
        case .allowed:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        }
    }
}
