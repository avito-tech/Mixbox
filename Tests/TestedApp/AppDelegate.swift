import UIKit
import MixboxInAppServices
import MixboxIpc

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: TouchDrawingWindow?
    var ipcClient: IpcClient?
    
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
        
        #if DEBUG
        if ProcessInfo.processInfo.environment["MIXBOX_IPC_STARTER_TYPE"] != nil {
            if let mixboxInAppServices = mixboxInAppServices {
                let customIpcMethods = CustomIpcMethods(
                    uiEventHistoryProvider: uiEventHistoryTracker
                )
                
                // TODO: add environment to be able to disable registration of methods?
                customIpcMethods.registerIn(mixboxInAppServices)
                
                (_, ipcClient) = mixboxInAppServices.start()
            }
        }
        #endif
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
