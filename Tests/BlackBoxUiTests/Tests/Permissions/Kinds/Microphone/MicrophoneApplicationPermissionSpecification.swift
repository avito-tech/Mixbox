import MixboxTestsFoundation

final class MicrophoneApplicationPermissionSpecification: ApplicationPermissionSpecification {
    var identifier: String {
        return "microphone"
    }
    
    func setter(permissions: ApplicationPermissionsSetter) -> ApplicationPermissionSetter {
        return permissions.microphone
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
