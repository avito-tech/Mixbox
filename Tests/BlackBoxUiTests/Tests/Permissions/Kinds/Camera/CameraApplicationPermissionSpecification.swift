import MixboxTestsFoundation

final class CameraApplicationPermissionSpecification: ApplicationPermissionSpecification {
    var identifier: String {
        return "camera"
    }
    
    func setter(permissions: ApplicationPermissionsSetter) -> ApplicationPermissionSetter {
        return permissions.camera
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
