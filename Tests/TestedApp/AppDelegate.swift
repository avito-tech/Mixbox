import UIKit
import MixboxInAppServices

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    
    #if DEBUG
    let mixboxInAppServices = MixboxInAppServices()
    #endif

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let uiEventHistoryTracker = UiEventHistoryTracker()
        
        window = TouchDrawingWindow(
            frame: UIScreen.main.bounds,
            uiEventObserver: uiEventHistoryTracker
        )
        
        let viewController: UIViewController
        
        if let screenNameForUiTests = ProcessInfo.processInfo.environment["MB_TESTS_screenName"] {
            // Inside UI tests
            
            #if DEBUG
            if let mixboxInAppServices = mixboxInAppServices {
                let customIpcMethods = CustomIpcMethods(
                    uiEventHistoryProvider: uiEventHistoryTracker
                )
                
                // TODO: add environment to be able to disable registration of methods?
                customIpcMethods.registerIn(mixboxInAppServices)
                
                mixboxInAppServices.start()
            }
            #endif
            
            viewController = TestingViewController(
                testingViewControllerSettings: TestingViewControllerSettings(
                    name: screenNameForUiTests,
                    mixboxInAppServices: mixboxInAppServices
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
