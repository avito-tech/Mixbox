import MixboxFoundation
import MixboxTestsFoundation

// При запуске приложения из теста из под fbxctest (да, именно вызова XCUIApplication.launch)
// сбрасываются права (частично). То есть до launch были, например, выставлены права для камеры и галереи,
// после launch остались только для галереи. В fbxctest есть код, который это делает, я дебажил, но он не выполнялся
// и права не терлись. Но я дебажил локально, через запуск fbxctest из командной строки, а не в запуске из тимсити.
//
// Это костыль. Если у вас есть желание продолжить мой пятидневный труд, можете выпилить это и отладить запуск на CI,
// чтобы записи в TCC.db не сбрасывались fbxctest'ом. Это будет правильно, так как нам хочется из теста
// определять права, и также не хочется зависеть от fbxctest (иметь возможность запускать из Xcode).

public final class AtApplicationLaunchApplicationPermissionSetter:
    ApplicationPermissionSetter,
    ApplicationDidLaunchObserver
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
    
    // MARK: - ApplicationDidLaunchObserver
    
    public func applicationDidLaunch() {
        codeToExecuteAfterLaunch?()
    }
}
