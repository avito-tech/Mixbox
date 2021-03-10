import MixboxTestsFoundation

public final class FakeSettingsAppNotificationsApplicationPermissionSetterFactory:
    NotificationsApplicationPermissionSetterFactory
{
    private let fakeSettingsAppBundleId: String
    private let testFailureRecorder: TestFailureRecorder
    
    public init(
        fakeSettingsAppBundleId: String,
        testFailureRecorder: TestFailureRecorder)
    {
        self.fakeSettingsAppBundleId = fakeSettingsAppBundleId
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func notificationsApplicationPermissionSetter(
        bundleId: String,
        displayName: String)
        -> ApplicationPermissionWithoutNotDeterminedStateSetter
    {
        return FakeSettingsAppNotificationsApplicationPermissionSetter(
            bundleId: bundleId,
            displayName: displayName,
            fakeSettingsAppBundleId: fakeSettingsAppBundleId,
            testFailureRecorder: testFailureRecorder
        )
    }
}
