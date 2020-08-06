import UIKit

#if DEBUG
import MixboxFoundation
import MixboxInAppServices
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    #if DEBUG
    var inAppServices: InAppServices?
    var startedInAppServices: StartedInAppServices?
    #endif
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        #if DEBUG
        let factoryOrNil = InAppServicesDependenciesFactoryImpl(
            environment: ProcessInfo.processInfo.environment,
            performanceLogger: NoopPerformanceLogger()
        )
        
        if let factory = factoryOrNil {
            inAppServices = InAppServices(
                inAppServicesDependenciesFactory: factory
            )
        } else {
            inAppServices = nil
        }
        
        startedInAppServices = inAppServices?.start()
        
        #endif
        
        return true
    }
}
