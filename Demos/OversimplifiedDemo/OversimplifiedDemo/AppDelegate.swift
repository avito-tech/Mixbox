import UIKit

#if DEBUG
import MixboxInAppServices
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    #if DEBUG
    var mixboxInAppServices: MixboxInAppServices?
    #endif
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        #if DEBUG
        if ProcessInfo.processInfo.environment["MIXBOX_ENABLE_IN_APP_SERVICES"] == "true" {
            let mixboxInAppServices = MixboxInAppServices()
            
            self.mixboxInAppServices = mixboxInAppServices
            
            mixboxInAppServices?.start()
        }
        #endif
        
        return true
    }
}
