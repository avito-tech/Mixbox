import MixboxFoundation
import MixboxTestsFoundation

public final class FakeSettingsAppNotificationsApplicationPermissionSetter:
    ApplicationPermissionWithoutNotDeterminedStateSetter
{
    private let bundleId: String
    private let displayName: String
    private let fakeSettingsAppBundleId: String
    private let testFailureRecorder: TestFailureRecorder
    
    private var timeoutInsideApp: TimeInterval {
        return 60
    }
    
    private var timeoutWaitingApp: TimeInterval {
        return timeoutInsideApp + 10
    }
    
    public init(
        bundleId: String,
        displayName: String,
        fakeSettingsAppBundleId: String,
        testFailureRecorder: TestFailureRecorder)
    {
        self.bundleId = bundleId
        self.displayName = displayName
        self.fakeSettingsAppBundleId = fakeSettingsAppBundleId
        self.testFailureRecorder = testFailureRecorder
    }
    
    public func set(_ state: AllowedDeniedState) {
        let notificationPermissionsManager = XCUIApplication(
            bundleIdentifier: fakeSettingsAppBundleId
        )
        
        notificationPermissionsManager.launchEnvironment["bundleIdentifier"] = bundleId
        notificationPermissionsManager.launchEnvironment["displayName"] = displayName
        notificationPermissionsManager.launchEnvironment["timeout"] = "\(timeoutInsideApp)"
        
        notificationPermissionsManager.launchEnvironment["status"] = statusString(
            state: state
        )
        
        notificationPermissionsManager.launch()
        
        let fakeSettingsAppStatusElement = notificationPermissionsManager.staticTexts["fakeSettingsAppStatus"]
        
        if !fakeSettingsAppStatusElement.exists && !fakeSettingsAppStatusElement.waitForExistence(timeout: timeoutWaitingApp) {
            testFailureRecorder.recordFailure(
                description: "Timed out waiting status of fake settings application (timeout = \(timeoutWaitingApp))",
                shouldContinueTest: false
            )
        } else {
            let status = fakeSettingsAppStatusElement.label
            
            if status == "OK" {
                // ok
            } else {
                testFailureRecorder.recordFailure(
                    description: "Fake settings application reported non-OK status: \(status)",
                    shouldContinueTest: false
                )
            }
        }
        
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
