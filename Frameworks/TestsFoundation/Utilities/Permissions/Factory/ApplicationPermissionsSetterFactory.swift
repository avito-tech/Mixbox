import MixboxTestsFoundation

public protocol ApplicationPermissionsSetterFactory: class {
    func applicationPermissionsSetter(
        bundleId: String,
        displayName: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionsSetter
}
