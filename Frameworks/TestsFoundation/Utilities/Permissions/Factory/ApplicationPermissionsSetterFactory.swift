import MixboxReporting

public protocol ApplicationPermissionsSetterFactory {
    func applicationPermissionsSetter(
        bundleId: String,
        displayName: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionsSetter
}
