import MixboxTestsFoundation

public protocol TccDbApplicationPermissionSetterFactory: class {
    func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionSetter
}
