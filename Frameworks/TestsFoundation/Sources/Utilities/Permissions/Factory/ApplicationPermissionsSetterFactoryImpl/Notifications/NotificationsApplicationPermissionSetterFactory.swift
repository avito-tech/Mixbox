public protocol NotificationsApplicationPermissionSetterFactory: AnyObject {
    func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
}
