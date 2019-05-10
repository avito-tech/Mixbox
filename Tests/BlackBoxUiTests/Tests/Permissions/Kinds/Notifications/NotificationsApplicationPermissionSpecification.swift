import MixboxTestsFoundation

final class NotificationsApplicationPermissionSpecification:
    ApplicationPermissionWithAllowedDeniedStateSpecification
{
    var identifier: String {
        return "notifications"
    }
    
    func setter(permissions: ApplicationPermissionsSetter) -> ApplicationPermissionWithoutNotDeterminedStateSetter {
        return permissions.notifications
    }
    
    func authorizationStatusString(state: AllowedDeniedState) -> String {
        switch state {
        case .allowed:
            return "authorized"
        case .denied:
            return "denied"
        }
    }
}
