import MixboxTestsFoundation

final class PhotosApplicationPermissionSpecification: ApplicationPermissionSpecification {
    var identifier: String {
        return "photos"
    }
    
    func setter(permissions: ApplicationPermissionsSetter) -> ApplicationPermissionSetter {
        return permissions.photos
    }
    
    func authorizationStatusString(state: AllowedDeniedNotDeterminedState) -> String {
        switch state {
        case .allowed:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        }
    }
}
