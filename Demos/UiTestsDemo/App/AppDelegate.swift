import UIKit

#if DEBUG
import MixboxFoundation
import MixboxInAppServices
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    #if DEBUG
    var mixboxInAppServices: MixboxInAppServices?
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
            mixboxInAppServices = MixboxInAppServices(
                inAppServicesDependenciesFactory: factory
            )
        } else {
            mixboxInAppServices = nil
        }
        
        startedInAppServices = mixboxInAppServices?.start()
        
        #endif
        
        return true
    }
}
