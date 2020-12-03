import MixboxTestsFoundation

// Use this with TccDbApplicationPermissionSetter if you are running tests via fbxctest
// For running with Xcode and xcodebuild use TccDbApplicationPermissionSetterFactory
public final class AtApplicationLaunchTccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory {
    private let applicationLifecycleObservable: ApplicationLifecycleObservable
    private let testFailureRecorder: TestFailureRecorder
    private let tccDbFactory: TccDbFactory
    
    public init(
        applicationLifecycleObservable: ApplicationLifecycleObservable,
        testFailureRecorder: TestFailureRecorder,
        tccDbFactory: TccDbFactory)
    {
        self.applicationLifecycleObservable = applicationLifecycleObservable
        self.testFailureRecorder = testFailureRecorder
        self.tccDbFactory = tccDbFactory
    }
    
    public func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String)
        -> ApplicationPermissionSetter
    {
        let wrappedSetter = TccDbApplicationPermissionSetter(
            service: service,
            testFailureRecorder: testFailureRecorder,
            tccPrivacySettingsManager: TccPrivacySettingsManagerImpl(
                bundleId: bundleId,
                tccDbFactory: tccDbFactory
            )
        )
        
        let setter = AtApplicationLaunchApplicationPermissionSetter(
            applicationPermissionSetter: wrappedSetter
        )
        
        applicationLifecycleObservable.addObserver(setter)
        
        return setter
    }
}
