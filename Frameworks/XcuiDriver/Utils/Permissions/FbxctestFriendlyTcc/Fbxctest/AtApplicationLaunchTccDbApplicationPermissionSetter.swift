import MixboxFoundation
import MixboxTestsFoundation

// When application is started inside fbxctest (by XCUIApplication.launch) the permissions are being partially reset.
// For example, access to camera and photos was allowed, but after launch only access to photos is allowed.
// This is because there is a code in fbxctest that do it. I tried to debug it, but failed to isolate the problem,
// but it is definitely there. Maybe it is because I tried to debug on my local machine.
//
// This is a kludge. If you want to continue my 5-day journey into this problem, you're welcome. It would be better if
// records in TCC.db will not be affected by fbxctest (or its dependency, or poorly configured XCTest, or something else).
// We don't want to have kludges, or depend on behavior of fbxctest. We want to set everything from tests.

public final class AtApplicationLaunchApplicationPermissionSetter:
    ApplicationPermissionSetter,
    ApplicationLifecycleObserver
{
    private var codeToExecuteAfterLaunch: (() -> ())?
    private let applicationPermissionSetter: ApplicationPermissionSetter
    
    public init(applicationPermissionSetter: ApplicationPermissionSetter) {
        self.applicationPermissionSetter = applicationPermissionSetter
    }
    
    // MARK: - ApplicationPermissionSetter
    
    public func set(_ state: AllowedDeniedNotDeterminedState) {
        let setPermission: () -> () = { [weak self] in
            self?.wrappedSet(state)
        }
        
        // If something (like fbxctest) resets permissions after app is launched,
        // this code will set permissions back.
        codeToExecuteAfterLaunch = setPermission
        
        // We also want our permissions set immediately.
        setPermission()
        
        // So with those two calls to `setPermission` we will have proper permissions most of the time.
    }
    
    private func wrappedSet(_ state: AllowedDeniedNotDeterminedState) {
        applicationPermissionSetter.set(state)
    }
    
    // MARK: - ApplicationLifecycleObserver
    
    public func applicationStateChanged(applicationIsLaunched: Bool) {
        if applicationIsLaunched {
            codeToExecuteAfterLaunch?()
        }
    }
}
