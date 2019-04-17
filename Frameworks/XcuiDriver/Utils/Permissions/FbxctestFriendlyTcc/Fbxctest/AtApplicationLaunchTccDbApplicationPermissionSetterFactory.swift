import MixboxTestsFoundation
import MixboxReporting

// Use this with TccDbApplicationPermissionSetter if you are running tests via fbxctest
// For running with Xcode and xcodebuild use TccDbApplicationPermissionSetterFactory
public final class AtApplicationLaunchTccDbApplicationPermissionSetterFactory: TccDbApplicationPermissionSetterFactory {
    private let applicationLifecycleObservable: ApplicationLifecycleObservable
    
    public init(applicationLifecycleObservable: ApplicationLifecycleObservable) {
        self.applicationLifecycleObservable = applicationLifecycleObservable
    }
    
    public func tccDbApplicationPermissionSetter(
        service: TccService,
        bundleId: String,
        testFailureRecorder: TestFailureRecorder)
        -> ApplicationPermissionSetter
    {
        let wrappedSetter = TccDbApplicationPermissionSetter(
            service: service,
            bundleId: bundleId,
            testFailureRecorder: testFailureRecorder
        )
        
        let setter = AtApplicationLaunchApplicationPermissionSetter(
            applicationPermissionSetter: wrappedSetter
        )
        
        applicationLifecycleObservable.addObserver(setter)
        
        return setter
    }
}
