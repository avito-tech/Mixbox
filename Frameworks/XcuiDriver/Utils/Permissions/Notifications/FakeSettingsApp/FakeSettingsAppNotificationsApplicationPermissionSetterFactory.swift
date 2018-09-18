import MixboxTestsFoundation

public final class FakeSettingsAppNotificationsApplicationPermissionSetterFactory:
    NotificationsApplicationPermissionSetterFactory
{
    private let fakeSettingsAppBundleId: String
    
    public init(
        fakeSettingsAppBundleId: String)
    {
        self.fakeSettingsAppBundleId = fakeSettingsAppBundleId
    }
    
    public func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
    {
        return FakeSettingsAppNotificationsApplicationPermissionSetter(
            bundleId: bundleId,
            displayName: displayName,
            fakeSettingsAppBundleId: fakeSettingsAppBundleId
        )
    }
}
