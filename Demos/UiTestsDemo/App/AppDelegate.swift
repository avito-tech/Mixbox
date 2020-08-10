import UIKit

#if DEBUG
import MixboxFoundation
import MixboxInAppServices
import MixboxBuiltinDi
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    #if DEBUG
    
    let inAppServices: InAppServices
    var startedInAppServices: StartedInAppServices?
    
    #endif
    
    override init() {
        #if DEBUG
        
        inAppServices = InAppServicesImpl(
            dependencyInjection: BuiltinDependencyInjection(),
            dependencyCollectionRegisterer: InAppServicesDefaultDependencyCollectionRegisterer()
        )
        
        #endif
        
        super.init()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool
    {
        #if DEBUG
        
        startedInAppServices = inAppServices.start()
        
        #endif
        
        return true
    }
}
