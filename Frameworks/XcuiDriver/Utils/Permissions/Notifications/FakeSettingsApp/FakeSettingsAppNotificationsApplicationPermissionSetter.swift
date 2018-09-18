import MixboxFoundation
import MixboxTestsFoundation

public final class FakeSettingsAppNotificationsApplicationPermissionSetter:
    ApplicationPermissionWithoutNotDeterminedStateSetter
{
    private let bundleId: String
    private let displayName: String
    private let fakeSettingsAppBundleId: String
    
    public init(
        bundleId: String,
        displayName: String,
        fakeSettingsAppBundleId: String)
    {
        self.bundleId = bundleId
        self.displayName = displayName
        self.fakeSettingsAppBundleId = fakeSettingsAppBundleId
    }
    
    public func set(_ state: AllowedDeniedState) {
        let notificationPermissionsManager = XCUIApplication(
            bundleIdentifier: fakeSettingsAppBundleId
        )
        
        notificationPermissionsManager.launchEnvironment["bundleIdentifier"] = bundleId
        notificationPermissionsManager.launchEnvironment["displayName"] = displayName
        
        notificationPermissionsManager.launchEnvironment["status"] = statusString(
            state: state
        )
        
        notificationPermissionsManager.launchEnvironment["runApplication"] = "true"
        
        notificationPermissionsManager.launch()
        notificationPermissionsManager.terminate()
    }
    
    private func statusString(state: AllowedDeniedState) -> String {
        switch state {
        case .allowed:
            return "allowed"
        case .denied:
            return "denied"
        }
    }
}
