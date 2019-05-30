public protocol NotificationsApplicationPermissionSetterFactory: class {
    func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
}
