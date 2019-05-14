import MixboxTestsFoundation

public protocol NotificationsApplicationPermissionSetterFactory {
    func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
}

