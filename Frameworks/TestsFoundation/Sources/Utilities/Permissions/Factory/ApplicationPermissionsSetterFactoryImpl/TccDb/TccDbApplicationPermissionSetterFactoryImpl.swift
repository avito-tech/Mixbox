import MixboxUiKit

// Suitable for running via Xcode and xcodebuild
// For running with fbxctest use AtApplicationLaunchTccDbApplicationPermissionSetterFactory
public final class TccDbApplicationPermissionSetterFactoryImpl: TccDbApplicationPermissionSetterFactory {
    private let testFailureRecorder: TestFailureRecorder
    private let tccDbFactory: TccDbFactory
    
    public init(
        testFailureRecorder: TestFailureRecorder,
        tccDbFactory: TccDbFactory)
    {
        self.testFailureRecorder = testFailureRecorder
        self.tccDbFactory = tccDbFactory
    }
    
    public func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String)
        -> ApplicationPermissionSetter
    {
        return TccDbApplicationPermissionSetter(
            service: service,
            testFailureRecorder: testFailureRecorder,
            tccPrivacySettingsManager: TccPrivacySettingsManagerImpl(
                bundleId: bundleId,
                tccDbFactory: tccDbFactory
            )
        )
    }
}
