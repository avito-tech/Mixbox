import UIKit
import MixboxInAppServices

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    #if DEBUG
    let mixboxInAppServices = MixboxInAppServices()
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = TouchDrawingWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TestingViewController(
            testingViewControllerSettings: TestingViewControllerSettings(
                name: ProcessInfo.processInfo.environment["MB_TESTS_screenName"] ?? ""
            )
        )
        window?.makeKeyAndVisible()
        
        #if DEBUG
        if let mixboxInAppServices = mixboxInAppServices {
            mixboxInAppServices.start()
            mixboxInAppServices.handleUiBecomeVisible()
            
            // TODO: add environment to be able to disable registration of methods?
            CustomIpcMethods.registerIn(mixboxInAppServices)
        }
        #endif
        
        return true
    }
}
