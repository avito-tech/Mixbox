import UIKit
import MixboxInAppServices

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    #if DEBUG
    let mixboxInAppServices = MixboxInAppServices()
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = TouchDrawingWindow(frame: UIScreen.main.bounds)
        
        let viewController: UIViewController
        
        if let screenNameForUiTests = ProcessInfo.processInfo.environment["MB_TESTS_screenName"] {
            // Inside UI tests
            
            #if DEBUG
            if let mixboxInAppServices = mixboxInAppServices {
                // TODO: add environment to be able to disable registration of methods?
                CustomIpcMethods.registerIn(mixboxInAppServices)
                
                mixboxInAppServices.start()
                mixboxInAppServices.handleUiBecomeVisible()
            }
            #endif
            
            viewController = TestingViewController(
                testingViewControllerSettings: TestingViewControllerSettings(
                    name: screenNameForUiTests
                )
            )
        } else {
            viewController = UIViewController()
            viewController.view.backgroundColor = .white
        }
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
