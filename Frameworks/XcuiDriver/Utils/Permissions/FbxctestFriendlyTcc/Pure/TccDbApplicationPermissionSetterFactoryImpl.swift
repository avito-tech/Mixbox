import MixboxReporting
import MixboxTestsFoundation

// Suitable for running via Xcode and xcodebuild
// For running with fbxctest use AtApplicationLaunchTccDbApplicationPermissionSetterFactory
public final class TccDbApplicationPermissionSetterFactoryImpl: TccDbApplicationPermissionSetterFactory {
    public init() {
    }
    
    public func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionSetter
    {
        return TccDbApplicationPermissionSetter(
            service: service,
            bundleId: bundleId,
            testFailureRecorder: testFailureRecorder
        )
    }
}
