import MixboxReporting

public protocol TccDbApplicationPermissionSetterFactory {
    func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionSetter
}
